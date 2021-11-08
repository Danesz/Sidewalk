import Foundation

func readAsset(fileName: String, ext: String) -> String? {
    if
        let pathWithinBundle = Bundle.module.url(forResource: fileName, withExtension: ext),
        let asset = readAssetAsString(asset: pathWithinBundle) {
        return asset
    } else {
        return nil
    }
}

func readAssetAsString(asset: URL) -> String? {
    let fileData = try? Data(contentsOf: asset)
    let fileString = String(data: fileData!, encoding: .utf8)
    return fileString
}
