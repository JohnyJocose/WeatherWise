//
//  CodeDictionaries.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/11/23.
//

import UIKit

public var weatherCodeDayDict: [Int: UIImage] = [
    1000: UIImage(systemName:"sun.max.fill")!,
    1003: UIImage(systemName:"cloud.sun.fill")!,
    1006: UIImage(systemName:"cloud")!,
    1009: UIImage(systemName:"cloud.fill")!,
    1030: UIImage(systemName:"cloud.fog")!,
    1063: UIImage(systemName:"cloud.sun.rain")!,
    1066: UIImage(systemName:"cloud.snow")!,
    1069: UIImage(systemName:"cloud.sleet")!,
    1072: UIImage(systemName:"cloud.hail")!,
    1087: UIImage(systemName:"cloud.sun.bolt")!,
    1114: UIImage(systemName:"cloud.sleet.fill")!,
    1117: UIImage(systemName:"cloud.snow.fill")!,
    1135: UIImage(systemName:"cloud.fog.fill")!,
    1147: UIImage(systemName:"cloud.fog.fill")!,
    1150: UIImage(systemName:"cloud.drizzle")!,
    1153: UIImage(systemName:"cloud.drizzle.fill")!,
    1168: UIImage(systemName:"cloud.hail")!,
    1171: UIImage(systemName:"cloud.hail.fill")!,
    1180: UIImage(systemName:"cloud.sun.rain")!,
    1183: UIImage(systemName:"cloud.rain")!,
    1186: UIImage(systemName:"cloud.sun.rain.fill")!,
    1189: UIImage(systemName:"cloud.rain.fill")!,
    1192: UIImage(systemName:"cloud.heavyrain")!,
    1195: UIImage(systemName:"cloud.heavyrain.fill")!,
    1198: UIImage(systemName:"cloud.hail")!,
    1201: UIImage(systemName:"cloud.hail.fill")!,
    1204: UIImage(systemName:"cloud.sleet")!,
    1207: UIImage(systemName:"cloud.sleet.fill")!,
    1210: UIImage(systemName:"cloud.snow")!,
    1213: UIImage(systemName:"cloud.snow")!,
    1216: UIImage(systemName:"cloud.snow")!,
    1219: UIImage(systemName:"cloud.snow.fill")!,
    1222: UIImage(systemName:"cloud.snow.fill")!,
    1225: UIImage(systemName:"cloud.snow.fill")!,
    1237: UIImage(systemName:"cloud.hail.fill")!,
    1240: UIImage(systemName:"cloud.sun.rain")!,
    1243: UIImage(systemName:"cloud.sun.rain.fill")!,
    1246: UIImage(systemName:"cloud.sun.rain.fill")!,
    1249: UIImage(systemName:"cloud.sleet")!,
    1252: UIImage(systemName:"cloud.sleet.fill")!,
    1255: UIImage(systemName:"cloud.snow")!,
    1258: UIImage(systemName:"cloud.snow.fill")!,
    1261: UIImage(systemName:"cloud.hail")!,
    1264: UIImage(systemName:"cloud.hail.fill")!,
    1273: UIImage(systemName:"cloud.sun.bolt.fill")!,
    1276: UIImage(systemName:"cloud.bolt.rain.fill")!,
    1279: UIImage(systemName:"cloud.sun.bolt.fill")!,
    1282: UIImage(systemName:"cloud.bolt.rain.fill")!
]

public var weatherCodeNightDict: [Int: UIImage] = [
    1000: UIImage(systemName:"moon.fill")!,
    1003: UIImage(systemName:"cloud.moon.fill")!,
    1006: UIImage(systemName:"cloud")!,
    1009: UIImage(systemName:"cloud.fill")!,
    1030: UIImage(systemName:"cloud.fog")!,
    1063: UIImage(systemName:"cloud.moon.rain")!,
    1066: UIImage(systemName:"cloud.snow")!,
    1069: UIImage(systemName:"cloud.sleet")!,
    1072: UIImage(systemName:"cloud.hail")!,
    1087: UIImage(systemName:"cloud.moon.bolt")!,
    1114: UIImage(systemName:"cloud.sleet.fill")!,
    1117: UIImage(systemName:"cloud.snow.fill")!,
    1135: UIImage(systemName:"cloud.fog.fill")!,
    1147: UIImage(systemName:"cloud.fog.fill")!,
    1150: UIImage(systemName:"cloud.drizzle")!,
    1153: UIImage(systemName:"cloud.drizzle.fill")!,
    1168: UIImage(systemName:"cloud.hail")!,
    1171: UIImage(systemName:"cloud.hail.fill")!,
    1180: UIImage(systemName:"cloud.moon.rain")!,
    1183: UIImage(systemName:"cloud.rain")!,
    1186: UIImage(systemName:"cloud.moon.rain.fill")!,
    1189: UIImage(systemName:"cloud.rain.fill")!,
    1192: UIImage(systemName:"cloud.heavyrain")!,
    1195: UIImage(systemName:"cloud.heavyrain.fill")!,
    1198: UIImage(systemName:"cloud.hail")!,
    1201: UIImage(systemName:"cloud.hail.fill")!,
    1204: UIImage(systemName:"cloud.sleet")!,
    1207: UIImage(systemName:"cloud.sleet.fill")!,
    1210: UIImage(systemName:"cloud.snow")!,
    1213: UIImage(systemName:"cloud.snow")!,
    1216: UIImage(systemName:"cloud.snow")!,
    1219: UIImage(systemName:"cloud.snow.fill")!,
    1222: UIImage(systemName:"cloud.snow.fill")!,
    1225: UIImage(systemName:"cloud.snow.fill")!,
    1237: UIImage(systemName:"cloud.hail.fill")!,
    1240: UIImage(systemName:"cloud.moon.rain")!,
    1243: UIImage(systemName:"cloud.moon.rain.fill")!,
    1246: UIImage(systemName:"cloud.moon.rain.fill")!,
    1249: UIImage(systemName:"cloud.sleet")!,
    1252: UIImage(systemName:"cloud.sleet.fill")!,
    1255: UIImage(systemName:"cloud.snow")!,
    1258: UIImage(systemName:"cloud.snow.fill")!,
    1261: UIImage(systemName:"cloud.hail")!,
    1264: UIImage(systemName:"cloud.hail.fill")!,
    1273: UIImage(systemName:"cloud.moon.bolt.fill")!,
    1276: UIImage(systemName:"cloud.bolt.rain.fill")!,
    1279: UIImage(systemName:"cloud.moon.bolt.fill")!,
    1282: UIImage(systemName:"cloud.bolt.rain.fill")!
]


//public var weatherCodeDict: [Int: String] = [
//    1000: "113",
//    1003: "116",
//    1006: "119",
//    1009: "122",
//    1030: "143",
//    1063: "176",
//    1066: "179",
//    1069: "182",
//    1072: "185",
//    1087: "200",
//    1114: "227",
//    1117: "230",
//    1135: "248",
//    1147: "260",
//    1150: "263",
//    1153: "266",
//    1168: "281",
//    1171: "284",
//    1180: "293",
//    1183: "296",
//    1186: "299",
//    1189: "302",
//    1192: "305",
//    1195: "308",
//    1198: "311",
//    1201: "314",
//    1204: "317",
//    1207: "320",
//    1210: "323",
//    1213: "326",
//    1216: "329",
//    1219: "332",
//    1222: "335",
//    1225: "338",
//    1237: "350",
//    1240: "353",
//    1243: "356",
//    1246: "359",
//    1249: "362",
//    1252: "365",
//    1255: "368",
//    1258: "371",
//    1261: "374",
//    1264: "377",
//    1273: "386",
//    1276: "389",
//    1279: "392",
//    1282: "395"
//]


public var moonDict: [String: UIImage] = [
    "New Moon": UIImage(systemName:"moonphase.new.moon.inverse")!,
    "Waxing Crescent": UIImage(systemName:"moonphase.waxing.crescent.inverse")!,
    "First Quarter": UIImage(systemName:"moonphase.first.quarter.inverse")!,
    "Waxing Gibbous": UIImage(systemName:"moonphase.waxing.gibbous.inverse")!,
    "Full Moon": UIImage(systemName:"moonphase.full.moon.inverse")!,
    "Waning Gibbous": UIImage(systemName:"moonphase.waning.gibbous.inverse")!,
    "Last Quarter": UIImage(systemName:"moonphase.last.quarter.inverse")!,
    "Waning Crescent": UIImage(systemName:"moonphase.waning.crescent.inverse")!
]

//public var moonDict: [String: UIImage] = [
//    "New Moon": UIImage(systemName:"moonphase.new.moon")!,
//    "Waxing Crescent": UIImage(systemName:"moonphase.waxing.crescent")!,
//    "First Quarter": UIImage(systemName:"moonphase.first.quarter")!,
//    "Waxing Gibbous": UIImage(systemName:"moonphase.waxing.gibbous")!,
//    "Full Moon": UIImage(systemName:"moonphase.full.moon")!,
//    "Waning Gibbous": UIImage(systemName:"moonphase.waning.gibbous")!,
//    "Last Quarter": UIImage(systemName:"moonphase.last.quarter")!,
//    "Waning Crescent": UIImage(systemName:"moonphase.waning.crescent")!
//]
