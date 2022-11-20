//
// SleepDetector.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class SleepDetectorInput : MLFeatureProvider {

    /// accs as 1 by 3 matrix of floats
    var accs: MLMultiArray

    /// hvs as 1 by 5 matrix of floats
    var hvs: MLMultiArray

    /// hds as 1 by 5 matrix of floats
    var hds: MLMultiArray

    var featureNames: Set<String> {
        get {
            return ["accs", "hvs", "hds"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "accs") {
            return MLFeatureValue(multiArray: accs)
        }
        if (featureName == "hvs") {
            return MLFeatureValue(multiArray: hvs)
        }
        if (featureName == "hds") {
            return MLFeatureValue(multiArray: hds)
        }
        return nil
    }
    
    init(accs: MLMultiArray, hvs: MLMultiArray, hds: MLMultiArray) {
        self.accs = accs
        self.hvs = hvs
        self.hds = hds
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    convenience init(accs: MLShapedArray<Float>, hvs: MLShapedArray<Float>, hds: MLShapedArray<Float>) {
        self.init(accs: MLMultiArray(accs), hvs: MLMultiArray(hvs), hds: MLMultiArray(hds))
    }

}


/// Model Prediction Output Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class SleepDetectorOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// out as multidimensional array of floats
    var out_: MLMultiArray {
        return self.provider.featureValue(for: "out")!.multiArrayValue!
    }

    /// out as multidimensional array of floats
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    var out_ShapedArray: MLShapedArray<Float> {
        return MLShapedArray<Float>(self.out_)
    }

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(out_: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["out" : MLFeatureValue(multiArray: out_)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class SleepDetector {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "SleepDetector", withExtension:"mlmodelc")!
    }

    /**
        Construct SleepDetector instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of SleepDetector.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `SleepDetector.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct SleepDetector instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct SleepDetector instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct SleepDetector instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<SleepDetector, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct SleepDetector instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> SleepDetector {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct SleepDetector instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<SleepDetector, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(SleepDetector(model: model)))
            }
        }
    }

    /**
        Construct SleepDetector instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> SleepDetector {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return SleepDetector(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as SleepDetectorInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SleepDetectorOutput
    */
    func prediction(input: SleepDetectorInput) throws -> SleepDetectorOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as SleepDetectorInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SleepDetectorOutput
    */
    func prediction(input: SleepDetectorInput, options: MLPredictionOptions) throws -> SleepDetectorOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return SleepDetectorOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - accs as 1 by 3 matrix of floats
            - hvs as 1 by 5 matrix of floats
            - hds as 1 by 5 matrix of floats

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SleepDetectorOutput
    */
    func prediction(accs: MLMultiArray, hvs: MLMultiArray, hds: MLMultiArray) throws -> SleepDetectorOutput {
        let input_ = SleepDetectorInput(accs: accs, hvs: hvs, hds: hds)
        return try self.prediction(input: input_)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - accs as 1 by 3 matrix of floats
            - hvs as 1 by 5 matrix of floats
            - hds as 1 by 5 matrix of floats

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SleepDetectorOutput
    */

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func prediction(accs: MLShapedArray<Float>, hvs: MLShapedArray<Float>, hds: MLShapedArray<Float>) throws -> SleepDetectorOutput {
        let input_ = SleepDetectorInput(accs: accs, hvs: hvs, hds: hds)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [SleepDetectorInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [SleepDetectorOutput]
    */
    func predictions(inputs: [SleepDetectorInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [SleepDetectorOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [SleepDetectorOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  SleepDetectorOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
