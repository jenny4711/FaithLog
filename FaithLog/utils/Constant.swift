//
//  Constant.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI

// 임시로 하드코딩된 데이터 사용
let address: [Bible] = [
   
    
    
    Bible(title: "선택하기", label: "선택하기", value: "선택하기", pg: 2, version: "", initial: "",enTitle:""),
    Bible(title: "갈라디아서", label: "갈라디아서", value: "갈라디아서", pg: 6, version: "신약", initial: "gal", enTitle: "Galatians"),
    Bible(title: "고린도전서", label: "고린도전서", value: "고린도전서", pg: 16, version: "신약", initial: "co_1", enTitle: "1 Corinthians"),
  Bible(title: "고린도후서", label: "고린도후서", value: "고린도후서", pg: 13, version: "신약", initial: "co_2",enTitle:"2 Corinthians"),
  Bible(title: "골로새서", label: "골로새서", value: "골로새서", pg: 4, version: "신약", initial: "col",enTitle:"Colossians"),
  
  Bible(title: "나훔", label: "나훔", value: "나훔", pg: 3, version: "구약", initial: "nah",enTitle:"Nahum"),
  Bible(title: "느헤미야기", label: "느헤미야기", value: "느헤미야기", pg: 13, version: "구약", initial: "neh",enTitle:"Nehemiah"),
  Bible(title: "누가복음", label: "누가복음", value: "누가복음", pg: 24, version: "신약", initial: "luk",enTitle:"Luke"),

  
  Bible(title:"다니엘", label: "다니엘", value: "다니엘", pg: 12, version: "구약", initial:"dan",enTitle:"Daniel"),
  Bible(title: "디도서", label: "디도서", value: "디도서", pg: 3, version: "신약", initial: "tit",enTitle:"Titus"),
  Bible(title: "디모데전서", label: "디모데전서", value: "디모데전서", pg: 6, version: "신약", initial: "ti1",enTitle:"1 Timothy"),
  Bible(title:"데살로니가후서",label:"데살로니가후서",value:"데살로니가후서", pg:3, version:"신약", initial:"th2",enTitle:"2 Thessalonians"),
  Bible(title:"데살로니가전서",label:"데살로니가전서", value:"데살로니가전서", pg: 5, version:"신약", initial:"th1",enTitle:"1 Thessalonians"),
  
  Bible(title: "레위기", label: "레위기", value: "레위기", pg: 27, version: "구약", initial: "lev",enTitle:"Leviticus"),
  Bible(title: "로마서", label: "로마서", value: "로마서", pg: 16, version: "신약", initial: "rom",enTitle:"Romans"),
  Bible(title: "룻기", label: "룻기", value: "룻기", pg: 4, version: "구약", initial: "ruth",enTitle:"Ruth"),
  
  Bible(title: "마태복음", label: "마태복음", value: "마태복음", pg: 28, version: "신약", initial: "mat",enTitle:"Matthew"),
  Bible(title: "마가복음", label: "마가복음", value: "마가복음", pg: 16, version: "신약", initial: "mark",enTitle:"Mark"),
  Bible(title: "말라기", label: "말라기", value: "말라기", pg: 4, version: "구약", initial: "mal",enTitle:"Malachi"),
  Bible(title: "미가", label: "미가", value: "미가", pg: 7, version: "구약", initial: "mic",enTitle:"Micah"),
  Bible(title: "민수기", label: "민수기", value: "민수기", pg: 36, version: "구약", initial: "nums",enTitle:"Numbers"),
  
  Bible(title: "빌립보서", label: "빌립보서", value: "빌립보서", pg: 4, version: "신약", initial: "phi",enTitle:"Philippians"),
  Bible(title:"빌레몬서",label:"빌레몬서",value: "빌레몬서",pg:1,version:"신약",initial: "phm",enTitle:"Philemon"),
  Bible(title: "베드로전서", label: "베드로전서", value: "베드로전서", pg: 5, version: "신약", initial: "pe1",enTitle:"1 Peter"),
  Bible(title: "베드로후서", label: "베드로후서", value: "베드로후서", pg: 3, version: "신약", initial: "pe2",enTitle:"2 Peter"),
  
  Bible(title: "사도행전", label: "사도행전", value: "사도행전", pg: 28, version: "신약", initial: "acts",enTitle:"Acts"),
  Bible(title: "사사기", label: "사사기", value: "사사기", pg: 21, version: "구약", initial: "judg",enTitle:"Judges"),
  Bible(title: "사무엘상", label:"사무엘상", value:"사무엘상", pg: 31, version: "구약", initial: "sam1",enTitle:"1 Samuel"),
  Bible(title: "사무엘하", label: "사무엘하", value: "사무엘하", pg: 24, version: "구약", initial: "sam2",enTitle:"2 Samuel"),
    Bible(title: "시편", label: "시편", value: "시편", pg: 150, version: "구약", initial: "psa",enTitle:"Psalms"),
  Bible(title: "신명기", label: "신명기", value:"신명기", pg: 34, version: "구약", initial: "deut",enTitle:"Deuteronomy"),
  Bible(title: "스가랴", label: "스가랴", value: "스가랴", pg: 14, version: "구약", initial: "zech",enTitle:"Zechariah"),
  Bible(title: "스바냐", label: "스바냐", value: "스바냐", pg: 3, version: "구약", initial: "zep",enTitle:"Zephaniah"),
  
  Bible(title: "아가", label:"아가", value: "아가", pg: 8, version: "구약", initial: "sol",enTitle:"Song of Songs"),
  Bible(title: "이사야서", label: "이사야서", value: "이사야서", pg: 66, version: "구약", initial: "isa",enTitle:"Isaiah "),
  Bible(title: "요한복음", label: "요한복음", value: "요한복음", pg: 21, version: "신약", initial: "joh",enTitle:"John"),
  Bible(title: "야고보서", label: "야고보서", value: "야고보서", pg: 5, version: "신약", initial: "jam",enTitle:"James"),
  Bible(title: "요한1서", label: "요한1서", value: "요한1서", pg: 5, version: "신약", initial: "john1",enTitle:"1 John"),
  Bible(title: "요한2서", label: "요한2서", value: "요한2서", pg: 1, version: "신약", initial: "jo2",enTitle:"2 John"),
  Bible(title: "요한3서", label: "요한3서", value: "요한3서", pg: 1, version: "신약", initial: "jo3",enTitle:"3 John"),
  Bible(title: "요한복음", label: "요한복음", value: "요한복음", pg: 21, version: "신약", initial: "joh",enTitle:"John"),
  Bible(title: "여호수아기", label: "여호수아기", value: "여호수아기", pg: 24, version: "구약", initial: "josh",enTitle:"Joshua"),
  Bible(title: "열왕기상", label: "열왕기상", value: "열왕기상", pg: 22, version: "구약", initial: "king1",enTitle:"1 Kings"),
  Bible(title: "열왕기하", label: "열왕기하", value: "열왕기하", pg: 25, version: "구약", initial: "king2",enTitle:"2 Kings"),
  Bible(title: "예베소서", label: "예베소서", value: "예베소서", pg: 6, version: "신약", initial: "eph",enTitle:"Ephesians"),
  Bible(title: "요한계시록", label: "요한계시록", value: "요한계시록", pg: 22, version: "신약", initial: "rev",enTitle:"Revelation"),
  Bible(title:"유다서",label:"유다서",value: "유다서",pg:1,version: "구약",initial: "jud",enTitle:"Jude"),
  Bible(title: "요나", label: "요나", value: "요나", pg: 4, version: "구약", initial: "jon",enTitle:"Jonah"),
  Bible(title:"아모스", label: "아모스", value: "아모스", pg: 9, version: "구약", initial: "amos",enTitle:"Amos"),
  Bible(title: "요엘", label: "요엘", value: "요엘", pg: 3, version:"구약", initial: "joe",enTitle:"Joel"),
  Bible(title: "에스더", label: "에스더", value: "에스더", pg: 10, version: "구약", initial: "est",enTitle:"Esther"),
  Bible(title: "에스라", label: "에스라", value: "에스라", pg:10, version: "구약", initial: "ezra",enTitle:"Ezra"),
  Bible(title: "역대상", label: "역대상", value: "역대상", pg: 29, version: "구약", initial: "chr1",enTitle:"1 Chronicles"),
  Bible(title: "역대하", label: "역대하", value: "역대하", pg: 36, version: "구약", initial: "chr2",enTitle:"2 Chronicles"),
  Bible(title:"욥기", label:"욥기", value:"욥기", pg: 42, version: "구약", initial: "job",enTitle:"Job"),
  Bible(title: "에스겔", label: "에스겔", value: "에스겔", pg: 48, version: "구약", initial: "eze",enTitle:"Ezekiel"),
  Bible(title: "예레미야 애가", label:  "예레미야 애가", value:  "예레미야 애가", pg: 5, version: "구약", initial: "lam",enTitle:"Lamentations"),
  Bible(title: "예레미야", label: "예레미야", value: "예레미야", pg: 52, version: "구약", initial: "jer",enTitle:"Jeremiah"),
 
  
  
  
  

    Bible(title: "잠언", label: "잠언", value: "잠언", pg: 31, version: "구약", initial: "pro", enTitle: "Proverbs"),
  
  


    Bible(title:"창세기", label:"창세기", value:"창세기", pg: 50, version:"구약", initial: "gen", enTitle: "Genesis"),
    Bible(title: "출애굽기", label: "출애굽기", value: "출애굽기", pg: 40, version: "구약", initial: "exo", enTitle: "Exodus"),
    Bible(title: "전도서", label: "전도서", value: "전도서", pg: 12, version: "구약", initial: "ecc", enTitle: "Ecclesiastes"),
 

  
 
  

    Bible(title: "하박국", label: "하박국", value: "하박국", pg: 3, version: "구약", initial: "hab", enTitle: "Habakkuk"),
    Bible(title: "학개", label: "학개", value: "학개", pg: 2, version: "구약", initial: "hag", enTitle: "Haggai"),
    Bible(title: "히브리서", label: "히브리서", value: "히브리서", pg: 13, version: "신약", initial: "heb", enTitle: "Hebrews"),
    Bible(title: "호세아", label: "호세아", value: "호세아", pg: 14, version: "구약", initial: "hos", enTitle: "Hosea"),
    
]
 let sampleAddress:Bible = address[0]
