//
//  HealthKitManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import HealthKit

internal class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()

    @Published var stepCount = 0
    @Published var heartRate = 0.0
    @Published var bodyMassIndex = 0.0

    func requestAuthorization() {
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        ]

        let writeTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        ]

        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, _ in
            if success {
                self.fetchStepCount()
                self.fetchHeartRate()
                self.fetchBodyMassIndex()
            }
        }
    }

    func fetchStepCount() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            DispatchQueue.main.async {
                self.stepCount = Int(sum.doubleValue(for: HKUnit.count()))
            }
        }

        healthStore.execute(query)
    }

    func fetchHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) { _, samples, _ in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.last else {
                return
            }
            DispatchQueue.main.async {
                self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }

        healthStore.execute(query)
    }

    func fetchBodyMassIndex() {
        let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(
            sampleType: bmiType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) { _, samples, _ in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.last else {
                return
            }
            DispatchQueue.main.async {
                self.bodyMassIndex = sample.quantity.doubleValue(for: HKUnit.count())
            }
        }

        healthStore.execute(query)
    }
}
