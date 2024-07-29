//
//  QuizView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import ResearchKit
import SwiftUI

internal struct QuizView: View {
    let level: String
    @State private var isPresenting = false
    @State private var result: ORKTaskResult?

    var body: some View {
        VStack {
            Text("Level: \(level)")
                .font(.title)
                .padding()

            Button("Begin Quiz") {
                isPresenting = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isPresenting) {
            ResearchKitView(result: $result, level: level)
        }
    }
}

internal struct ResearchKitView: UIViewControllerRepresentable {
    @Binding var result: ORKTaskResult?
    let level: String

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let task = createTask(for: level)
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = context.coordinator
        return taskViewController
    }

    func updateUIViewController(_: ORKTaskViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(result: $result)
    }

    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        @Binding var result: ORKTaskResult?

        init(result: Binding<ORKTaskResult?>) {
            _result = result
        }

        func taskViewController(
            _ taskViewController: ORKTaskViewController,
            didFinishWith _: ORKTaskViewControllerFinishReason,
            error _: Error?) {
            result = taskViewController.result
            taskViewController.dismiss(animated: true, completion: nil)
        }
    }

    func createTask(for level: String) -> ORKOrderedTask {
        let steps = createQuizSteps(for: level)
        return ORKOrderedTask(identifier: "iOSDevQuiz", steps: steps)
    }

    func createQuizSteps(for level: String) -> [ORKStep] {
        var steps: [ORKStep] = []

        let introStep = ORKInstructionStep(identifier: "IntroStep")
        introStep.title = "iOS Development Quiz"
        introStep.text = "Welcome to the \(level) level quiz on iOS development and Swift."
        steps.append(introStep)

        switch level {
        case "Beginner":
            steps += createBeginnerQuestions()
        case "Intermediate":
            steps += createIntermediateQuestions()
        case "Advanced":
            steps += createAdvancedQuestions()
        default:
            break
        }

        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Quiz Completed"
        completionStep.text = "Thank you for taking the quiz!"
        steps.append(completionStep)

        return steps
    }

    func createBeginnerQuestions() -> [ORKQuestionStep] {
        let question1 = ORKQuestionStep(
            identifier: "BeginnerQ1",
            title: "Swift Basics",
            question: "What keyword is used to declare a constant in Swift?",
            answer: ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
                ORKTextChoice(text: "var", value: "var" as NSString),
                ORKTextChoice(text: "let", value: "let" as NSString),
                ORKTextChoice(text: "const", value: "const" as NSString),
                ORKTextChoice(text: "final", value: "final" as NSString)
            ]))

        // TODO: Add more beginner questions...

        return [question1]
    }

    func createIntermediateQuestions() -> [ORKQuestionStep] {
        let question1 = ORKQuestionStep(
            identifier: "IntermediateQ1",
            title: "Swift Optionals",
            question: "What is the purpose of optional chaining in Swift?",
            answer: ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
                ORKTextChoice(text: "To create multiple optionals", value: "multiple" as NSString),
                ORKTextChoice(text: "To safely access properties of an optional", value: "safeAccess" as NSString),
                ORKTextChoice(text: "To convert optionals to non-optionals", value: "convert" as NSString),
                ORKTextChoice(text: "To create optional protocols", value: "protocols" as NSString)
            ]))

        // TODO: Add more intermediate questions...

        return [question1]
    }

    func createAdvancedQuestions() -> [ORKQuestionStep] {
        let question1 = ORKQuestionStep(
            identifier: "AdvancedQ1",
            title: "Swift Concurrency",
            question: "Which keyword is used to define an asynchronous function in Swift?",
            answer: ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
                ORKTextChoice(text: "async", value: "async" as NSString),
                ORKTextChoice(text: "await", value: "await" as NSString),
                ORKTextChoice(text: "concurrent", value: "concurrent" as NSString),
                ORKTextChoice(text: "parallel", value: "parallel" as NSString)
            ]))

        // TODO: Add more advanced questions...

        return [question1]
    }
}
