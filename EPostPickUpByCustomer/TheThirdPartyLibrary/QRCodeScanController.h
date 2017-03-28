
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol PassQRCodeDelegate <NSObject>

- (void) passQRCode : (NSString *) qrCode;

@end

@interface QRCodeScanController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) id <PassQRCodeDelegate> qrCodeDelegate;

@end
