/*
 * ============================================================================ *
* Want a clear path for learning AutoHotkey?                                   *
* Take a look at our AutoHotkey courses here: the-Automator.com/Discover          *
* They're structured in a way to make learning AHK EASY                        *
* And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
* ============================================================================ *
*/
#Requires AutoHotkey v2+
#Include ..\NotifyV2.ahk
;********************Example 1***********************************
; Following will play notify with sound
Notify.Show({BDText:'Playing Sound tada',GenSound:'tada'})

;********************Example 2***********************************
; Following will play notify with sound
Notify.Show({BDText:"Playing Sound File using Path with few more Notify parameters ", HDText:"The Automator", GenBGcolor:"silver", BDFontSize:"15",GenSound:"C:\Windows\Media\Windows Shutdown.wav"})


;********************Example 3***********************************
; User can also play Following sound mentioned in AHK documentation https://www.autohotkey.com/docs/v2/lib/SoundPlay.htm
; *-1 = Simple beep. If the sound card is not available, the sound is generated using the speaker.
; *16 = Hand (stop/error)
; *32 = Question
; *48 = Exclamation
; *64 = Asterisk (info)
Notify.Show({BDText:'Playing Sound Hand Stop/error',GenSound:'*16'})

;********************Example 4***********************************
; Playing MidiFile. these take while to start
Notify.Show({BDText:'Playing midi file for 60 Seconds; takes a bit to start',GenSound:'..\Audio\Need a Hero.mid',GenDuration:60})

;********************Example 5***********************************
; Example 5 will be moved to callback  examples

;********************Example 6***********************************
; It will also Scan 'a_scriptdir \res\' for Audio files and list them with WIndow Default Sounds
Notify.SoundList()   ; List of Supported Sounds


;********************Example 7***********************************
; Second Notification will cancels out first notification sound
Notify.Show({BDText:'First Notify Sound tada',GenSound:'tada'}) ; sound for tada canceled by ding right after
Notify.Show({BDText:'Second Notify Sound Ding',GenSound:'Ding'})



