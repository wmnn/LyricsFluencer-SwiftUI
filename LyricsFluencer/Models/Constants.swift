//
//  Constants.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 20.02.23.
//

import Foundation

struct STATIC{
    static let API_ROOT = "https://www.lyricsfluencer.com"
    //static let API_ROOT = "http://localhost:8080"
    static let languages: [Language] = [
        /*Language(language: "af", name: "Afrikaans"),
        Language(language: "ak", name: "Akan"),
        Language(language: "sq", name: "Albanian"),
        Language(language: "am", name: "Amharic"),*/
        Language(language: "ar", name: "Arabic"),
        /*Language(language: "hy", name: "Armenian"),
        Language(language: "as", name: "Assamese"),
        Language(language: "ay", name: "Aymara"),
        Language(language: "az", name: "Azerbaijani"),
        Language(language: "bm", name: "Bambara"),
        Language(language: "eu", name: "Basque"),
        Language(language: "be", name: "Belarusian"),
        Language(language: "bn", name: "Bengali"),
        Language(language: "bho", name: "Bhojpuri"),
        Language(language: "bs", name: "Bosnian"),
        Language(language: "bg", name: "Bulgarian"),
        Language(language: "ca", name: "Catalan"),
        Language(language: "ceb", name: "Cebuano"),
        Language(language: "ny", name: "Chichewa"),
        Language(language: "zh", name: "Chinese (Simplified)"),
        Language(language: "zh-TW", name: "Chinese (Traditional)"),
        Language(language: "co", name: "Corsican"),
        Language(language: "hr", name: "Croatian"),
        Language(language: "cs", name: "Czech"),
        Language(language: "da", name: "Danish"),
        Language(language: "dv", name: "Divehi"),
        Language(language: "doi", name: "Dogri"),
        Language(language: "nl", name: "Dutch"),*/
        Language(language: "en", name: "English"),
        /*Language(language: "eo", name: "Esperanto"),
        Language(language: "et", name: "Estonian"),
        Language(language: "ee", name: "Ewe"),
        Language(language: "tl", name: "Filipino"),
        Language(language: "fi", name: "Finnish"),*/
        Language(language: "fr", name: "French"),
        /*Language(language: "fy", name: "Frisian"),
        Language(language: "gl", name: "Galician"),
        Language(language: "lg", name: "Ganda"),
        Language(language: "ka", name: "Georgian"),*/
        Language(language: "de", name: "German"),
        /*Language(language: "gom", name: "Goan Konkani"),
        Language(language: "el", name: "Greek"),
        Language(language: "gn", name: "Guarani"),
        Language(language: "gu", name: "Gujarati"),
        Language(language: "ht", name: "Haitian Creole"),
        Language(language: "ha", name: "Hausa"),
        Language(language: "haw", name: "Hawaiian"),
        Language(language: "iw", name: "Hebrew"),
        Language(language: "hi", name: "Hindi"),
        Language(language: "hmn", name: "Hmong"),
        Language(language: "hu", name: "Hungarian"),
        Language(language: "is", name: "Icelandic"),
        Language(language: "ig", name: "Igbo"),
        Language(language: "ilo", name: "Iloko"),
        Language(language: "id", name: "Indonesian"),
        Language(language: "ga", name: "Irish"),*/
        Language(language: "it", name: "Italian"),
        Language(language: "ja", name: "Japanese"),
        /*Language(language: "jw", name: "Javanese"),
        Language(language: "kn", name: "Kannada"),
        Language(language: "kk", name: "Kazakh"),
        Language(language: "km", name: "Khmer"),
        Language(language: "rw", name: "Kinyarwanda"),
        Language(language: "ko", name: "Korean"),
        Language(language: "kri", name: "Krio"),
        Language(language: "ku", name: "Kurdish (Kurmanji)"),
        Language(language: "ckb", name: "Kurdish (Sorani)"),
        Language(language: "ky", name: "Kyrgyz"),
        Language(language: "lo", name: "Lao"),
        Language(language: "la", name: "Latin"),
        Language(language: "lv", name: "Latvian"),
        Language(language: "ln", name: "Lingala"),
        Language(language: "lt", name: "Lithuanian"),
        Language(language: "lb", name: "Luxembourgish"),
        Language(language: "mk", name: "Macedonian"),
        Language(language: "mai", name: "Maithili"),
        Language(language: "mg", name: "Malagasy"),
        Language(language: "ms", name: "Malay"),
        Language(language: "ml", name: "Malayalam"),
        Language(language: "mt", name: "Maltese"),
        Language(language: "mni-Mtei", name: "Manipuri (Meitei Mayek)"),
        Language(language: "mi", name: "Maori"),
        Language(language: "mr", name: "Marathi"),
        Language(language: "lus", name: "Mizo"),
        Language(language: "mn", name: "Mongolian"),
        Language(language: "my", name: "Myanmar (Burmese)"),
        Language(language: "ne", name: "Nepali"),
        Language(language: "nso", name: "Northern Sotho"),
        Language(language: "no", name: "Norwegian"),
        Language(language: "or", name: "Odia (Oriya)"),
        Language(language: "om", name: "Oromo"),
        Language(language: "ps", name: "Pashto"),
        Language(language: "fa", name: "Persian"),
        Language(language: "pl", name: "Polish"),*/
        Language(language: "pt", name: "Portuguese"),
        /*Language(language: "pa", name: "Punjabi"),
        Language(language: "qu", name: "Quechua"),
        Language(language: "ro", name: "Romanian"),*/
        Language(language: "ru", name: "Russian"),
        /*Language(language: "sm", name: "Samoan"),
        Language(language: "sa", name: "Sanskrit"),
        Language(language: "gd", name: "Scots Gaelic"),
        Language(language: "sr", name: "Serbian"),
        Language(language: "st", name: "Sesotho"),
        Language(language: "sn", name: "Shona"),
        Language(language: "sd", name: "Sindhi"),
        Language(language: "si", name: "Sinhala"),
        Language(language: "sk", name: "Slovak"),
        Language(language: "sl", name: "Slovenian"),
        Language(language: "so", name: "Somali"),*/
        Language(language: "es", name: "Spanish"),
        /*Language(language: "su", name: "Sundanese"),
        Language(language: "sw", name: "Swahili"),
        Language(language: "sv", name: "Swedish"),
        Language(language: "tg", name: "Tajik"),
        Language(language: "ta", name: "Tamil"),
        Language(language: "tt", name: "Tatar"),
        Language(language: "te", name: "Telugu"),
        Language(language: "th", name: "Thai"),
        Language(language: "ti", name: "Tigrinya"),
        Language(language: "ts", name: "Tsonga"),*/
        //Language(language: "tr", name: "Turkish"),
        /*Language(language: "tk", name: "Turkmen"),
        Language(language: "uk", name: "Ukrainian"),
        Language(language: "ur", name: "Urdu"),
        Language(language: "ug", name: "Uyghur"),
        Language(language: "uz", name: "Uzbek"),
        Language(language: "vi", name: "Vietnamese"),
        Language(language: "cy", name: "Welsh"),
        Language(language: "xh", name: "Xhosa"),
        Language(language: "yi", name: "Yiddish"),
        Language(language: "yo", name: "Yoruba"),
        Language(language: "zu", name: "Zulu"),
        Language(language: "he", name: "Hebrew"),
        Language(language: "jv", name: "Javanese"),
        Language(language: "zh-CN", name: "Chinese (Simplified)")*/
    ]
}/*
struct LanguageModel: Codable, Identifiable {
    var language: String
    var name: String
    var id: String {
        language
    }
}

*/
