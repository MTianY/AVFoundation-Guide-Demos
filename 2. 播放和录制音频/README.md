### 二.播放和录制音频

#### 1.理解音频会话

音频会话在应用程序和操作系统之间扮演者中间人的角色.
所有 iOS 应用程序都具有音频会话,无论其是否使用.默认音频会话来自于以下一些预配置

- 激活了音频播放,但是音频录制未激活.
- 当用户切换响铃/静音开关到"静音"模式时,应用程序播放的所有音频都会消失
- 当设备显示解锁屏幕时,应用程序的音频处于静音状态
- 当应用程序播放音频时,所有后台播放的音频都会处于静音状态

#### 2.音频会话分类

`AV Foundation`定义了7种分类来描述应用程序所使用的音频行为.


| 分类 | 作用 | 是否允许混音 | 音频输入 | 音频输出 |
| :-: | :-: | :-: | :-: | :-: |
|  Ambient | 游戏、效率应用程序 | √ |  | √ |
| Solo Ambient(默认) | 游戏、效率应用程序 |  |  | √ |
| Playback |  音频和视频播放器 | 可选 |  | √ |
| Record |  录音机、音频捕捉 |  | √ |  |
|  Play and Record  | VoIP、语音聊天 | 可选 | √ | √ |
|  Audio Processing |  离线会话和处理 |  |  |  |
|  Multi-Route |  使用外部硬件的高级 A/V 应用程序 |  | √ | √ |


#### 3.配置音频会话

- 音频会话在应用程序的生命周期中是可以修改的,但通常我们只对其配置一次,就是在应用程序启动时.
- 配置音频会话的最佳位置就是应用程序代理的`application:didFinishLaunchingWithOptions:`方法.
- `AVAudioSession`提供了与应用程序音频会话交互的接口,所以开发者需要取得指向该单例的指针.通过设置合适的分类,开发者可为音频的播放指定需要的音频会话,其中定制一些行为.最后告知该音频会话激活该配置

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TYHomeViewController new]];
    [self.window makeKeyAndVisible];
    
    // 配置音频会话
    [self setupAudioSession];
    
    return YES;
}

// 配置音频会话
- (void)setupAudioSession {
    
    // 创建会话单例
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    // 设置需要的会话分类
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error: %@",[error localizedDescription]);
    }
    // 激活音频会话配置
    if (![audioSession setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@",[error localizedDescription]);
    }
    
}
```

#### 4.使用 `AVAudioPlayer`播放音频

##### 4.1 主要类: `AVAudioPlayer`  

- 这个类的实例提供了一种简单地从文本或内存中播放音频的方法.
- AVAudioPlayer 构建于 Core Audio 中的 C-based Audio Queue Services 的最顶层.所以它能提供所有你在 Audio Queue Services 中所能找到的核心功能.并且使用 OC 的接口.如:
    - 播放
    - 循环
    - 音频计量
    - 除非你需要从网络流中播放音频、需要访问原始音频样本或者需要非常低的延时,否则 AVAudioPlayer 都能胜任.

##### 4.2 创建 `AVAudioPlayer`
    
- 有两种方法创建`AVAudioPlayer`
    - 使用包含要播放音频的内存版本的 NSData
    - 使用本地音频文件的 NSURL 

    
```objc
- (void)setupAVAudioPlayer {
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    // 如果返回一个有效的播放实例,建议调用 prepareToPlay 方法.这样做会取得需要的音频硬件并预加载 Audio Queue 的缓冲区
    // 调用prepareToPlay 这个动作是可选的,当调用 play 方法时会隐性激活,不过在创建时准备播放器可以降低调用 play 方法和听到声音输出之间的延时.
    if (self.audioPlayer) {
        [self.audioPlayer prepareToPlay];
    }
    
}
```

##### 4.3 对播放进行控制

- play
    - 立即播放音频的功能 
- pause
    - 播放暂停 
- stop
    - 停止播放

`pause`和`stop`方法在应用程序外面看来实现的功能都是停止当前播放行为.当我们之后调用`play`方法时,通过`pause`和`stop`方法停止的音频都会继续播放.

**pause 和 stop的主要区别,在与底层的处理上**

- 调用 `stop`方法会撤销调用`prepareToPlay`时所作的设置.
- 而调用`pause`方法则不会.

**其他有趣的控制方法**

- 修改播放器的音量  
    - 播放器的音量独立于系统的音量,我们可以通过对播放器音量的处理实现很多有趣的效果,如声音的渐隐效果
    - 音量或播放增益定义为0.0(静音)到1.0(最大音量)之间的浮点值 
- 修改播放器的 pan 值
    - 允许使用立体声播放声音: 播放器的 pan 值由一个浮点数表示,范围从 -1.0(极左)到1.0(极右).默认值为0.0(居中). 
- 调整播放率
    - iOS 5版本中加入了一个强大功能,即允许用户在不改变音调的情况下调整播放率.范围从0.5(半速)到2.0(2倍速).如果正记录一首复杂的音乐或语音,放慢速度回有很大的帮助;当我们想快速浏览一份政府常规会议内容时,加速播放就很有帮助. 
- 通过设置 numberOfLoops 属性实现音频无缝循环
    - 给这个属性设置一个大于0的数,可以实现播放器 n 次循环播放.相反,设置为-1会导致播放器无限循环 
    - 音频循环可以是未压缩的线性 PCM 音频，也可以是诸如 AAC 之类的压缩格式音频。 MP3 文件片段可以实现无缝循环，但是 MP3 格式用作循环格式并不被推崇。MP3 格式的音 频要实现循环的目的通常需要使用特殊工具进行处理。如果希望使用压缩格式的资源，建议 使用诸如 AAC 或 AppleLossless 格式的内容。
- 进行音频计量
    - 当播放发生时从播放器读取音量力度的平均值及峰值.  
 
#### 5.创建 `Audio Looper`





