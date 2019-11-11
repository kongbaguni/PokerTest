//
//  TTSHelper.swift
//  test
//
//  Created by 서창열 on 2019/10/23.
//  Copyright © 2019 서창열. All rights reserved.
//

import Foundation
import AVKit

/** Text to Speech helper*/
class TTSHelper {
    static let shared = TTSHelper()
    private let synthesizer = AVSpeechSynthesizer()
    /** 언어 설정 */
    var language:String = "ko-KR"
    
    func speak(text:String, language:String? = nil, complete:@escaping()->Void) {
        if synthesizer.isSpeaking {
            return
        }
        if let lang = language {
            self.language = lang
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: self.language)
        utterance.rate = 0.4
        synthesizer.speak(utterance)

        func check(complete:@escaping()->Void) {
            if synthesizer.isSpeaking {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    check(complete: complete)
                }
            }
            else {
                DispatchQueue.main.async {
                    complete()
                }
            }
        }
        
        check {
            complete()
        }
        
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func resume() {
        synthesizer.continueSpeaking()
    }
}
