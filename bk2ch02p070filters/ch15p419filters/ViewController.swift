
import UIKit

class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView!
    let context = CIContext(options:nil)
    
    let which = 3 // 1, 2 work; 3 does not and never has, so why do they say it does?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let moi = UIImage(named:"Moi")!
        let moici = CIImage(image:moi)!
        let moiextent = moici.extent
        
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        let smallerDimension = min(moiextent.width, moiextent.height)
        let largerDimension = max(moiextent.width, moiextent.height)
        
        // first filter
        let grad = CIFilter(name: "CIRadialGradient")!
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * 0.85, forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        
        // second filter
        let blendimage = moici.imageByApplyingFilter(
            "CIBlendWithMask", withInputParameters: [
                "inputMaskImage":grad.outputImage
            ])
        
        // two ways to obtain final bitmap; third way, claimed to work, does not
        
        switch which {
        case 1:
            let moicg = self.context.createCGImage(blendimage, fromRect: moiextent)
            self.iv.image = UIImage(CGImage: moicg)
        case 2:
            UIGraphicsBeginImageContextWithOptions(moiextent.size, false, 0)
            UIImage(CIImage: blendimage).drawInRect(moiextent)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv.image = im
        case 3:
            self.iv.image = UIImage(CIImage: blendimage) // nope
        default: break
        }
        
    }
    
    
}
