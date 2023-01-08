# Share Extension `UIImage` Memory Bloat Bug Tester

This project repros a bug I've found in share (and action) extensions that receive images. It appears that share extensions that are provided `UIImage`s go through a *very* costly process when loading those images. So much memory is spent when loading images from `NSItemProvider` that the extensions often crash due to running out of memory for modern-sized photos. For some reason, images shared as `NSData` do not go through this costly path and load with no problems (i.e. a _much_ lower memory footprint) in share extensions.

|Image resolution|Memory consumed when loading from NSData|Memory consumed when loading from UIImage|
|--|--|--|
|48mp|[19.6MB](media/nsdata48mp.png)|[270.5MB](media/uiimage48mp.png)|
|12mp|[19.4MB](media/nsdata12mp.png)|[78MB](media/uiimage412mp.png)|
|7mp|[19.3](media/nsdata7mp.png)|[19.4MB](media/uiimage7mp.png)|

Share extensions that inherit from `SLComposeServiceViewController` consume even more memory because of the preview they load. It appears preview loading occurs even if `loadPreviewView` returns `nil`.

In practice, on device share extensions that receive images as NSData don't crash, whereas ones that receive UIImages do crash.

<video src="https://dl.dropboxusercontent.com/s/17wfnxw755lu77z/crash-wFTj.mp4"/>

The stack traces for these crashes appear to be adding UIImages to NSKeyedArchivers.

<img width="2672" alt="crash" src="https://user-images.githubusercontent.com/522951/211221317-60336709-f7fd-4353-95e2-c3bbd16dae39.png">

I wrote [a blog post](https://medium.com/ios-os-x-development/reduce-share-extension-crashes-from-your-app-with-this-one-weird-trick-6b86211bb175) recently encouraging developers to share images as `NSData` from their apps, but it seems like the OS shouldn't take such a costly path when delivering UIImages to share extensions. It seems like this is a flaw in the OS implementation for extension data loading, not something developers using `UIActivityViewController` should have to work around.

*Hat tip to [Paul Haddad](https://tapbots.social/@paul) for chatting with me about this while working on [Ivory](https://tapbots.social/@ivory). This was originally a bug report I wrote to him.*
