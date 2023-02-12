local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 1,["14"] = 1,["15"] = 1,["16"] = 1,["17"] = 1,["18"] = 2,["19"] = 2,["20"] = 4,["21"] = 9,["22"] = 10,["23"] = 9,["24"] = 10,["26"] = 10,["27"] = 12,["28"] = 13,["29"] = 9,["30"] = 17,["31"] = 19,["32"] = 20,["33"] = 21,["34"] = 22,["35"] = 17,["36"] = 25,["37"] = 27,["39"] = 27,["41"] = 28,["43"] = 28,["45"] = 25,["46"] = 10,["47"] = 9,["48"] = 10,["50"] = 10,["51"] = 32,["52"] = 33,["53"] = 32,["54"] = 33,["56"] = 33,["57"] = 35,["58"] = 36,["59"] = 37,["60"] = 41,["61"] = 42,["62"] = 32,["63"] = 44,["64"] = 46,["65"] = 46,["66"] = 47,["67"] = 47,["68"] = 49,["71"] = 54,["72"] = 55,["73"] = 44,["74"] = 58,["75"] = 60,["76"] = 58,["77"] = 63,["78"] = 65,["79"] = 65,["80"] = 67,["81"] = 68,["82"] = 69,["84"] = 72,["85"] = 73,["86"] = 74,["87"] = 75,["88"] = 75,["89"] = 75,["90"] = 75,["91"] = 75,["92"] = 75,["93"] = 75,["94"] = 75,["95"] = 75,["96"] = 78,["97"] = 78,["98"] = 78,["99"] = 78,["100"] = 78,["101"] = 78,["102"] = 78,["103"] = 78,["104"] = 78,["105"] = 80,["106"] = 80,["107"] = 80,["108"] = 80,["109"] = 80,["110"] = 80,["111"] = 80,["112"] = 80,["113"] = 81,["114"] = 81,["115"] = 81,["116"] = 81,["117"] = 81,["118"] = 81,["119"] = 81,["120"] = 81,["121"] = 82,["122"] = 82,["123"] = 82,["124"] = 82,["125"] = 82,["126"] = 82,["127"] = 82,["128"] = 82,["129"] = 63,["130"] = 85,["131"] = 87,["132"] = 85,["133"] = 90,["134"] = 92,["135"] = 90,["136"] = 95,["137"] = 97,["138"] = 95,["139"] = 100,["140"] = 102,["141"] = 100,["142"] = 105,["143"] = 107,["144"] = 105,["145"] = 33,["146"] = 32,["147"] = 33,["149"] = 33,["150"] = 114,["151"] = 115,["152"] = 114,["153"] = 115,["155"] = 115,["156"] = 117,["157"] = 118,["158"] = 114,["159"] = 122,["160"] = 124,["161"] = 125,["162"] = 126,["164"] = 126,["166"] = 127,["167"] = 122,["168"] = 130,["169"] = 132,["171"] = 132,["173"] = 133,["175"] = 133,["177"] = 130,["178"] = 115,["179"] = 114,["180"] = 115,["182"] = 115,["183"] = 137,["184"] = 138,["185"] = 137,["186"] = 138,["188"] = 138,["189"] = 140,["190"] = 141,["191"] = 145,["192"] = 137,["193"] = 147,["194"] = 149,["197"] = 154,["198"] = 155,["199"] = 155,["200"] = 156,["201"] = 147,["202"] = 159,["203"] = 161,["206"] = 166,["207"] = 159,["208"] = 169,["209"] = 171,["210"] = 171,["211"] = 173,["212"] = 174,["213"] = 175,["214"] = 176,["215"] = 176,["216"] = 176,["217"] = 176,["218"] = 176,["219"] = 176,["220"] = 176,["221"] = 176,["223"] = 180,["224"] = 181,["225"] = 181,["226"] = 181,["227"] = 181,["228"] = 181,["229"] = 181,["230"] = 181,["231"] = 181,["232"] = 181,["233"] = 183,["234"] = 183,["235"] = 183,["236"] = 183,["237"] = 183,["238"] = 183,["239"] = 183,["240"] = 183,["242"] = 186,["243"] = 187,["244"] = 187,["245"] = 187,["246"] = 187,["247"] = 187,["248"] = 187,["249"] = 187,["250"] = 187,["251"] = 169,["252"] = 190,["253"] = 192,["254"] = 190,["255"] = 195,["256"] = 197,["257"] = 195,["258"] = 138,["259"] = 137,["260"] = 138,["262"] = 138,["263"] = 204,["264"] = 205,["265"] = 204,["266"] = 205,["268"] = 205,["269"] = 207,["270"] = 208,["271"] = 210,["272"] = 216,["273"] = 217,["274"] = 218,["275"] = 219,["276"] = 204,["277"] = 221,["278"] = 223,["279"] = 224,["280"] = 225,["281"] = 226,["282"] = 227,["283"] = 228,["285"] = 228,["287"] = 229,["288"] = 221,["289"] = 232,["290"] = 234,["292"] = 234,["294"] = 232,["295"] = 237,["296"] = 239,["297"] = 240,["299"] = 240,["301"] = 241,["302"] = 242,["303"] = 243,["304"] = 237,["305"] = 246,["306"] = 248,["307"] = 250,["308"] = 251,["309"] = 252,["310"] = 253,["312"] = 256,["313"] = 246,["314"] = 259,["315"] = 261,["316"] = 262,["317"] = 264,["318"] = 266,["320"] = 266,["323"] = 270,["325"] = 270,["328"] = 259,["329"] = 274,["330"] = 276,["331"] = 276,["332"] = 276,["333"] = 276,["334"] = 276,["335"] = 276,["336"] = 276,["337"] = 276,["338"] = 276,["339"] = 276,["340"] = 276,["341"] = 276,["342"] = 276,["343"] = 279,["344"] = 281,["345"] = 283,["346"] = 283,["347"] = 283,["348"] = 283,["349"] = 283,["350"] = 283,["351"] = 281,["353"] = 294,["354"] = 295,["355"] = 295,["356"] = 297,["357"] = 299,["358"] = 301,["359"] = 303,["360"] = 303,["361"] = 303,["362"] = 303,["363"] = 303,["364"] = 303,["365"] = 301,["367"] = 314,["369"] = 274,["370"] = 318,["371"] = 320,["372"] = 320,["373"] = 322,["374"] = 323,["376"] = 325,["377"] = 327,["380"] = 329,["381"] = 330,["385"] = 333,["388"] = 335,["389"] = 336,["393"] = 339,["396"] = 341,["397"] = 342,["401"] = 345,["404"] = 347,["405"] = 348,["410"] = 353,["411"] = 354,["412"] = 355,["413"] = 356,["414"] = 356,["415"] = 356,["416"] = 356,["417"] = 356,["418"] = 357,["419"] = 357,["420"] = 357,["421"] = 357,["422"] = 357,["423"] = 358,["425"] = 362,["426"] = 363,["427"] = 364,["428"] = 364,["429"] = 364,["430"] = 364,["431"] = 364,["432"] = 365,["433"] = 365,["434"] = 365,["435"] = 365,["436"] = 365,["438"] = 318,["439"] = 369,["440"] = 371,["442"] = 371,["444"] = 369,["445"] = 374,["446"] = 376,["447"] = 374,["448"] = 205,["449"] = 204,["450"] = 205,["452"] = 205,["453"] = 383,["454"] = 384,["455"] = 383,["456"] = 384,["458"] = 384,["459"] = 386,["460"] = 390,["461"] = 391,["462"] = 392,["463"] = 383,["464"] = 394,["465"] = 396,["466"] = 397,["467"] = 398,["468"] = 399,["469"] = 400,["470"] = 394,["471"] = 403,["472"] = 405,["473"] = 406,["474"] = 407,["475"] = 403,["476"] = 410,["477"] = 412,["478"] = 414,["480"] = 418,["482"] = 410,["483"] = 422,["484"] = 424,["485"] = 422,["486"] = 427,["487"] = 429,["488"] = 427,["489"] = 432,["490"] = 434,["491"] = 432,["492"] = 437,["493"] = 439,["494"] = 437,["495"] = 442,["496"] = 444,["497"] = 442,["498"] = 447,["499"] = 449,["500"] = 447,["501"] = 452,["502"] = 452,["503"] = 457,["504"] = 459,["505"] = 457,["506"] = 462,["507"] = 464,["508"] = 462,["509"] = 384,["510"] = 383,["511"] = 384,["513"] = 384,["514"] = 468,["515"] = 469,["516"] = 468,["517"] = 469,["519"] = 469,["520"] = 474,["521"] = 475,["522"] = 476,["523"] = 468,["524"] = 478,["525"] = 480,["528"] = 485,["529"] = 486,["530"] = 487,["531"] = 488,["532"] = 489,["533"] = 490,["534"] = 478,["535"] = 493,["536"] = 495,["539"] = 500,["541"] = 502,["542"] = 504,["545"] = 506,["546"] = 507,["547"] = 507,["548"] = 509,["549"] = 510,["550"] = 510,["551"] = 510,["552"] = 511,["553"] = 511,["554"] = 511,["555"] = 512,["557"] = 512,["559"] = 513,["563"] = 516,["566"] = 518,["570"] = 521,["573"] = 523,["577"] = 527,["580"] = 529,["585"] = 534,["586"] = 536,["587"] = 536,["588"] = 538,["589"] = 539,["591"] = 539,["593"] = 540,["595"] = 493,["596"] = 544,["597"] = 546,["600"] = 551,["602"] = 551,["604"] = 552,["606"] = 552,["608"] = 553,["610"] = 553,["612"] = 554,["614"] = 554,["616"] = 555,["617"] = 555,["618"] = 555,["619"] = 555,["620"] = 555,["621"] = 555,["622"] = 555,["623"] = 555,["624"] = 556,["626"] = 556,["628"] = 544,["629"] = 559,["630"] = 561,["631"] = 559,["632"] = 564,["633"] = 566,["634"] = 564,["635"] = 469,["636"] = 468,["637"] = 469,["639"] = 469,["640"] = 570,["641"] = 571,["642"] = 570,["643"] = 571,["645"] = 571,["646"] = 573,["647"] = 575,["648"] = 580,["649"] = 581,["650"] = 582,["651"] = 584,["652"] = 585,["653"] = 570,["654"] = 587,["655"] = 589,["658"] = 594,["659"] = 595,["660"] = 596,["661"] = 597,["662"] = 597,["663"] = 598,["664"] = 587,["665"] = 601,["666"] = 603,["669"] = 608,["671"] = 608,["673"] = 609,["674"] = 609,["675"] = 610,["676"] = 610,["677"] = 611,["678"] = 611,["679"] = 612,["680"] = 613,["682"] = 613,["684"] = 615,["685"] = 617,["687"] = 601,["688"] = 621,["689"] = 623,["692"] = 628,["693"] = 628,["694"] = 629,["695"] = 630,["696"] = 631,["697"] = 631,["698"] = 632,["699"] = 621,["700"] = 635,["701"] = 637,["702"] = 637,["704"] = 637,["705"] = 637,["706"] = 637,["707"] = 637,["709"] = 638,["712"] = 638,["714"] = 638,["717"] = 638,["719"] = 639,["722"] = 639,["724"] = 639,["727"] = 639,["729"] = 637,["730"] = 641,["731"] = 643,["732"] = 647,["733"] = 648,["734"] = 643,["735"] = 645,["736"] = 645,["737"] = 645,["738"] = 645,["739"] = 645,["740"] = 645,["741"] = 643,["742"] = 655,["743"] = 655,["744"] = 657,["745"] = 657,["746"] = 657,["749"] = 657,["751"] = 657,["752"] = 657,["753"] = 657,["754"] = 657,["757"] = 635,["758"] = 662,["759"] = 664,["760"] = 664,["761"] = 666,["763"] = 669,["764"] = 670,["765"] = 671,["766"] = 662,["767"] = 674,["768"] = 676,["769"] = 677,["770"] = 677,["771"] = 677,["772"] = 677,["773"] = 677,["774"] = 677,["775"] = 677,["776"] = 686,["777"] = 674,["778"] = 689,["779"] = 691,["780"] = 689,["781"] = 694,["782"] = 696,["783"] = 694,["784"] = 699,["785"] = 701,["786"] = 699,["787"] = 571,["788"] = 570,["789"] = 571,["791"] = 571,["792"] = 705,["793"] = 706,["794"] = 705,["795"] = 706,["797"] = 706,["798"] = 708,["799"] = 705,["800"] = 713,["801"] = 715,["804"] = 720,["805"] = 721,["806"] = 722,["807"] = 713,["808"] = 725,["809"] = 727,["812"] = 732,["813"] = 725,["814"] = 735,["815"] = 737,["818"] = 742,["819"] = 735,["820"] = 745,["821"] = 747,["822"] = 747,["823"] = 749,["824"] = 751,["825"] = 751,["826"] = 751,["827"] = 751,["828"] = 751,["829"] = 751,["830"] = 749,["831"] = 745,["832"] = 762,["833"] = 764,["834"] = 764,["835"] = 766,["837"] = 769,["838"] = 770,["839"] = 770,["840"] = 770,["841"] = 770,["842"] = 770,["843"] = 770,["844"] = 770,["845"] = 770,["846"] = 762,["847"] = 773,["848"] = 775,["849"] = 773,["850"] = 778,["851"] = 780,["852"] = 778,["853"] = 783,["854"] = 785,["855"] = 783,["856"] = 706,["857"] = 705,["858"] = 706,["860"] = 706,["861"] = 789,["862"] = 790,["863"] = 789,["864"] = 790,["866"] = 790,["867"] = 792,["868"] = 793,["869"] = 794,["870"] = 799,["871"] = 800,["872"] = 789,["873"] = 802,["874"] = 804,["877"] = 809,["878"] = 810,["879"] = 811,["880"] = 811,["881"] = 812,["882"] = 812,["883"] = 802,["884"] = 815,["885"] = 817,["888"] = 822,["890"] = 822,["892"] = 823,["893"] = 823,["894"] = 824,["895"] = 824,["896"] = 825,["897"] = 825,["898"] = 826,["899"] = 827,["901"] = 827,["903"] = 828,["904"] = 828,["905"] = 828,["906"] = 828,["907"] = 828,["908"] = 828,["909"] = 828,["910"] = 828,["911"] = 828,["912"] = 830,["913"] = 832,["915"] = 815,["916"] = 836,["917"] = 838,["920"] = 843,["921"] = 843,["922"] = 844,["923"] = 844,["925"] = 836,["926"] = 847,["927"] = 849,["928"] = 847,["929"] = 852,["930"] = 854,["931"] = 852,["932"] = 857,["933"] = 859,["934"] = 857,["935"] = 790,["936"] = 789,["937"] = 790,["939"] = 790,["940"] = 866,["941"] = 867,["942"] = 866,["943"] = 867,["944"] = 872,["945"] = 874,["946"] = 875,["947"] = 875,["948"] = 875,["949"] = 875,["950"] = 875,["951"] = 875,["952"] = 875,["953"] = 875,["954"] = 876,["955"] = 877,["956"] = 878,["957"] = 872,["958"] = 881,["960"] = 883,["962"] = 883,["964"] = 884,["965"] = 885,["967"] = 885,["970"] = 881,["971"] = 867,["972"] = 866,["973"] = 867,["975"] = 867,["976"] = 889,["977"] = 890,["978"] = 889,["979"] = 890,["980"] = 892,["981"] = 894,["982"] = 895,["983"] = 895,["984"] = 895,["985"] = 895,["986"] = 895,["987"] = 895,["988"] = 895,["989"] = 895,["990"] = 905,["991"] = 892,["992"] = 908,["993"] = 910,["994"] = 908,["995"] = 913,["996"] = 915,["997"] = 913,["998"] = 918,["999"] = 920,["1000"] = 918,["1001"] = 923,["1002"] = 925,["1003"] = 923,["1004"] = 890,["1005"] = 889,["1006"] = 890,["1008"] = 890,["1009"] = 932,["1010"] = 933,["1011"] = 932,["1012"] = 933,["1013"] = 935,["1014"] = 937,["1015"] = 938,["1016"] = 940,["1017"] = 942,["1020"] = 946,["1021"] = 946,["1022"] = 946,["1023"] = 946,["1024"] = 946,["1025"] = 946,["1026"] = 935,["1027"] = 933,["1028"] = 932,["1029"] = 933,["1031"] = 933,["1032"] = 950,["1033"] = 951,["1034"] = 950,["1035"] = 951,["1037"] = 951,["1038"] = 953,["1039"] = 954,["1040"] = 956,["1041"] = 957,["1042"] = 958,["1043"] = 962,["1044"] = 963,["1045"] = 950,["1046"] = 965,["1047"] = 967,["1050"] = 972,["1051"] = 973,["1052"] = 974,["1053"] = 974,["1054"] = 975,["1055"] = 976,["1057"] = 976,["1059"] = 977,["1060"] = 965,["1061"] = 980,["1062"] = 982,["1065"] = 987,["1066"] = 980,["1067"] = 990,["1068"] = 992,["1072"] = 997,["1073"] = 999,["1076"] = 1001,["1080"] = 1004,["1083"] = 1006,["1087"] = 1009,["1090"] = 1011,["1091"] = 1012,["1096"] = 990,["1097"] = 1018,["1098"] = 1020,["1101"] = 1025,["1103"] = 1025,["1105"] = 1026,["1106"] = 1027,["1107"] = 1028,["1108"] = 1029,["1110"] = 1029,["1112"] = 1018,["1113"] = 1032,["1114"] = 1034,["1115"] = 1034,["1116"] = 1034,["1117"] = 1034,["1120"] = 1034,["1121"] = 1034,["1122"] = 1034,["1124"] = 1035,["1127"] = 1035,["1129"] = 1035,["1132"] = 1035,["1134"] = 1036,["1137"] = 1036,["1139"] = 1036,["1141"] = 1034,["1142"] = 1037,["1143"] = 1039,["1144"] = 1043,["1145"] = 1044,["1146"] = 1039,["1147"] = 1041,["1148"] = 1041,["1149"] = 1041,["1150"] = 1041,["1151"] = 1041,["1152"] = 1041,["1153"] = 1039,["1155"] = 1032,["1156"] = 1053,["1157"] = 1055,["1158"] = 1055,["1159"] = 1057,["1161"] = 1060,["1162"] = 1061,["1163"] = 1061,["1164"] = 1061,["1165"] = 1061,["1166"] = 1061,["1167"] = 1061,["1168"] = 1061,["1169"] = 1061,["1170"] = 1053,["1171"] = 1064,["1172"] = 1066,["1173"] = 1066,["1174"] = 1068,["1175"] = 1069,["1177"] = 1072,["1178"] = 1073,["1179"] = 1074,["1180"] = 1074,["1181"] = 1074,["1182"] = 1074,["1183"] = 1074,["1184"] = 1074,["1185"] = 1074,["1186"] = 1074,["1187"] = 1075,["1188"] = 1075,["1189"] = 1075,["1190"] = 1075,["1191"] = 1075,["1192"] = 1076,["1193"] = 1076,["1194"] = 1076,["1195"] = 1076,["1196"] = 1076,["1197"] = 1064,["1198"] = 1079,["1199"] = 1081,["1200"] = 1079,["1201"] = 1084,["1202"] = 1086,["1203"] = 1084,["1204"] = 951,["1205"] = 950,["1206"] = 951,["1208"] = 951,["1209"] = 1093,["1210"] = 1094,["1211"] = 1093,["1212"] = 1094,["1214"] = 1094,["1215"] = 1096,["1216"] = 1097,["1217"] = 1093,["1218"] = 1101,["1219"] = 1103,["1220"] = 1104,["1221"] = 1105,["1222"] = 1107,["1223"] = 1108,["1224"] = 1109,["1225"] = 1101,["1226"] = 1112,["1227"] = 1114,["1229"] = 1114,["1231"] = 1115,["1233"] = 1115,["1235"] = 1112,["1236"] = 1094,["1237"] = 1093,["1238"] = 1094,["1240"] = 1094,["1241"] = 1119,["1242"] = 1120,["1243"] = 1119,["1244"] = 1120,["1246"] = 1120,["1247"] = 1122,["1248"] = 1119,["1249"] = 1127,["1250"] = 1129,["1253"] = 1134,["1254"] = 1135,["1255"] = 1136,["1256"] = 1127,["1257"] = 1139,["1259"] = 1141,["1262"] = 1146,["1263"] = 1147,["1265"] = 1147,["1268"] = 1139,["1269"] = 1150,["1270"] = 1152,["1271"] = 1152,["1272"] = 1154,["1273"] = 1155,["1274"] = 1156,["1275"] = 1156,["1276"] = 1156,["1277"] = 1156,["1278"] = 1156,["1279"] = 1156,["1280"] = 1156,["1281"] = 1156,["1282"] = 1156,["1283"] = 1158,["1284"] = 1158,["1285"] = 1158,["1286"] = 1158,["1287"] = 1158,["1288"] = 1158,["1289"] = 1158,["1290"] = 1158,["1292"] = 1162,["1293"] = 1163,["1294"] = 1163,["1295"] = 1163,["1296"] = 1163,["1297"] = 1163,["1298"] = 1163,["1299"] = 1163,["1300"] = 1163,["1301"] = 1163,["1302"] = 1165,["1303"] = 1165,["1304"] = 1165,["1305"] = 1165,["1306"] = 1165,["1307"] = 1166,["1308"] = 1166,["1309"] = 1166,["1310"] = 1166,["1311"] = 1166,["1312"] = 1166,["1313"] = 1166,["1314"] = 1166,["1316"] = 1150,["1317"] = 1170,["1318"] = 1172,["1319"] = 1178,["1320"] = 1170,["1321"] = 1181,["1322"] = 1183,["1323"] = 1181,["1324"] = 1186,["1325"] = 1188,["1326"] = 1186,["1327"] = 1191,["1328"] = 1193,["1329"] = 1191,["1330"] = 1196,["1331"] = 1198,["1332"] = 1196,["1333"] = 1120,["1334"] = 1119,["1335"] = 1120,["1337"] = 1120,["1338"] = 1202,["1339"] = 1203,["1340"] = 1202,["1341"] = 1203,["1343"] = 1203,["1344"] = 1205,["1345"] = 1202,["1346"] = 1207,["1347"] = 1209,["1350"] = 1214,["1351"] = 1214,["1352"] = 1207,["1353"] = 1217,["1354"] = 1219,["1357"] = 1224,["1358"] = 1224,["1359"] = 1224,["1360"] = 1226,["1361"] = 1228,["1363"] = 1228,["1366"] = 1217,["1367"] = 1232,["1368"] = 1234,["1369"] = 1232,["1370"] = 1237,["1371"] = 1239,["1372"] = 1237,["1373"] = 1242,["1374"] = 1244,["1375"] = 1242,["1376"] = 1203,["1377"] = 1202,["1378"] = 1203,["1380"] = 1203});
local ____exports = {}
local ____dota_ts_adapter = require("tslib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("tslib.sleep_timer")
local Sleep = ____sleep_timer.Sleep
require("libraries.util")
____exports.musashi_dai_go_sei = __TS__Class()
local musashi_dai_go_sei = ____exports.musashi_dai_go_sei
musashi_dai_go_sei.name = "musashi_dai_go_sei"
__TS__ClassExtends(musashi_dai_go_sei, BaseAbility)
function musashi_dai_go_sei.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_01"
    self.SoundSfx = "musashi_dai_go_sei_sfx"
end
function musashi_dai_go_sei.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_0 = self.Caster
    if ____opt_0 ~= nil then
        ____opt_0:EmitSound(self.SoundVoiceline)
    end
    local ____opt_2 = self.Caster
    if ____opt_2 ~= nil then
        ____opt_2:EmitSound(self.SoundSfx)
    end
end
musashi_dai_go_sei = __TS__Decorate(
    {registerAbility(nil)},
    musashi_dai_go_sei
)
____exports.musashi_dai_go_sei = musashi_dai_go_sei
____exports.musashi_modifier_dai_go_sei = __TS__Class()
local musashi_modifier_dai_go_sei = ____exports.musashi_modifier_dai_go_sei
musashi_modifier_dai_go_sei.name = "musashi_modifier_dai_go_sei"
__TS__ClassExtends(musashi_modifier_dai_go_sei, BaseModifier)
function musashi_modifier_dai_go_sei.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    self.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    self.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
    self.BonusDmg = 0
    self.BonusAtkSpeed = 0
end
function musashi_modifier_dai_go_sei.prototype.OnCreated(self)
    local ____opt_4 = self:GetAbility()
    self.BonusDmg = ____opt_4 and ____opt_4:GetSpecialValueFor("BonusDmg")
    local ____opt_6 = self:GetAbility()
    self.BonusAtkSpeed = ____opt_6 and ____opt_6:GetSpecialValueFor("BonusAtkSpeed")
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self:CreateParticle()
end
function musashi_modifier_dai_go_sei.prototype.OnRefresh(self)
    self:OnCreated()
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ____opt_8 = self.Caster
    if ____opt_8 and ____opt_8:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf"
        self.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf"
        self.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf"
    end
    local BuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    local BlueOrbParticle = ParticleManager:CreateParticle(self.BlueOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local RedOrbParticle = ParticleManager:CreateParticle(self.RedOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControlEnt(
        BlueOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack2",
        Vector(0, 0, 0),
        false
    )
    ParticleManager:SetParticleControlEnt(
        RedOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        BuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BlueOrbParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        RedOrbParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_dai_go_sei.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function musashi_modifier_dai_go_sei.prototype.GetModifierPreAttack_BonusDamage(self)
    return self.BonusDmg
end
function musashi_modifier_dai_go_sei.prototype.GetModifierAttackSpeedBonus_Constant(self)
    return self.BonusAtkSpeed
end
function musashi_modifier_dai_go_sei.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_dai_go_sei.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_dai_go_sei = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_dai_go_sei
)
____exports.musashi_modifier_dai_go_sei = musashi_modifier_dai_go_sei
____exports.musashi_tengan = __TS__Class()
local musashi_tengan = ____exports.musashi_tengan
musashi_tengan.name = "musashi_tengan"
__TS__ClassExtends(musashi_tengan, BaseAbility)
function musashi_tengan.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_02"
    self.SoundSfx = "musashi_tengan_sfx"
end
function musashi_tengan.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_10 = self.Caster
    if ____opt_10 ~= nil then
        ____opt_10:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_12 = self.Caster
    if ____opt_12 ~= nil then
        ____opt_12:EmitSound(self.SoundVoiceline)
    end
    local ____opt_14 = self.Caster
    if ____opt_14 ~= nil then
        ____opt_14:EmitSound(self.SoundSfx)
    end
end
musashi_tengan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tengan
)
____exports.musashi_tengan = musashi_tengan
____exports.musashi_modifier_tengan = __TS__Class()
local musashi_modifier_tengan = ____exports.musashi_modifier_tengan
musashi_modifier_tengan.name = "musashi_modifier_tengan"
__TS__ClassExtends(musashi_modifier_tengan, BaseModifier)
function musashi_modifier_tengan.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_tengan_basic.vpcf"
    self.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf"
    self.BonusDmg = 0
end
function musashi_modifier_tengan.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_16 = self:GetAbility()
    self.BonusDmg = ____opt_16 and ____opt_16:GetSpecialValueFor("BonusDmg")
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_tengan.prototype.CreateParticle(self)
    local ____opt_18 = self.Caster
    if ____opt_18 and ____opt_18:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_tengan_unique.vpcf"
        self.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf"
        local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            OverheadParticle,
            10,
            self.Caster,
            PATTACH_OVERHEAD_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    end
    local BuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    self:AddParticle(
        BuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_tengan.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengan.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tengan = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengan
)
____exports.musashi_modifier_tengan = musashi_modifier_tengan
____exports.musashi_niou_kurikara = __TS__Class()
local musashi_niou_kurikara = ____exports.musashi_niou_kurikara
musashi_niou_kurikara.name = "musashi_niou_kurikara"
__TS__ClassExtends(musashi_niou_kurikara, BaseAbility)
function musashi_niou_kurikara.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_03"
    self.SoundSfx = "musashi_niou_kurikara_sfx"
    self.BasicAoeParticle = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf"
    self.TargetAoe = Vector(0, 0, 0)
    self.Interval = 0
    self.SlashCount = 0
    self.DmgPerSlash = 0
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseStart(self)
    self.Caster = self:GetCaster()
    self.NiouSkill = self.Caster:FindAbilityByName(____exports.musashi_niou.name)
    self.NiouSkill:CastAbility()
    self.Niou = self.NiouSkill.Niou
    self.TargetAoe = self:GetCursorPosition()
    local ____opt_20 = self.Niou
    if ____opt_20 ~= nil then
        ____opt_20:FaceTowards(self.TargetAoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_22 = self.NiouSkill
    if ____opt_22 ~= nil then
        ____opt_22:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    self.DmgPerSlash = self:GetSpecialValueFor("DmgPerSlash")
    local ____opt_24 = self.Niou
    if ____opt_24 ~= nil then
        ____opt_24:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    self.Interval = 0.5
    EmitGlobalSound(self.SoundVoiceline)
    self.SlashCount = self.SlashCount + 1
end
function musashi_niou_kurikara.prototype.OnChannelThink(self, interval)
    if self.Interval >= 0.5 and self.SlashCount < 5 then
        EmitSoundOnLocationWithCaster(self.TargetAoe, self.SoundSfx, self.Caster)
        self:CreateParticle()
        self:DoDamage()
        self.Interval = 0
    end
    self.Interval = self.Interval + interval
end
function musashi_niou_kurikara.prototype.OnChannelFinish(self, interrupted)
    self.SlashCount = 0
    self.Interval = 0
    if interrupted then
        local ____opt_26 = self.NiouSkill
        if ____opt_26 ~= nil then
            ____opt_26:DestroyNiou(0)
        end
    else
        local ____opt_28 = self.NiouSkill
        if ____opt_28 ~= nil then
            ____opt_28:DestroyNiou(1)
        end
    end
end
function musashi_niou_kurikara.prototype.DoDamage(self)
    local ____FindUnitsInRadius_32 = FindUnitsInRadius
    local ____opt_30 = self.Caster
    local Targets = ____FindUnitsInRadius_32(
        ____opt_30 and ____opt_30:GetTeam(),
        self.TargetAoe,
        nil,
        self:GetAOERadius(),
        self:GetAbilityTargetTeam(),
        self:GetAbilityTargetType(),
        self:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    for ____, Iterator in ipairs(Targets) do
        ApplyDamage({
            victim = Iterator,
            attacker = self.Caster,
            damage = self.DmgPerSlash,
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self
        })
    end
    self.SlashCount = self.SlashCount + 1
    local ____opt_33 = self.Caster
    local ModifierTengan = ____opt_33 and ____opt_33:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if self.SlashCount == 5 and ModifierTengan then
        for ____, Iterator in ipairs(Targets) do
            ApplyDamage({
                victim = Iterator,
                attacker = self.Caster,
                damage = ModifierTengan.BonusDmg,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                ability = self
            })
        end
        ModifierTengan:Destroy()
    end
end
function musashi_niou_kurikara.prototype.CreateParticle(self)
    local ____opt_35 = self.Caster
    if ____opt_35 and ____opt_35:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch41 = self.SlashCount
            local ____cond41 = ____switch41 == 1
            if ____cond41 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond41 = ____cond41 or ____switch41 == 2
            if ____cond41 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond41 = ____cond41 or ____switch41 == 3
            if ____cond41 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond41 = ____cond41 or ____switch41 == 4
            if ____cond41 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf"
                    break
                end
            end
        until true
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local CrackParticle = ParticleManager:CreateParticle(CrackParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(0, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            12,
            Vector(400, 0, 0)
        )
        ParticleManager:SetParticleControl(CrackParticle, 0, self.TargetAoe)
    else
        local AoeParticle = ParticleManager:CreateParticle(self.BasicAoeParticle, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            2,
            Vector(400, 0, 0)
        )
    end
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_37 = self.NiouSkill
    if ____opt_37 ~= nil then
        ____opt_37:SetLevel(self:GetLevel())
    end
end
function musashi_niou_kurikara.prototype.GetAOERadius(self)
    return self:GetSpecialValueFor("Radius")
end
musashi_niou_kurikara = __TS__Decorate(
    {registerAbility(nil)},
    musashi_niou_kurikara
)
____exports.musashi_niou_kurikara = musashi_niou_kurikara
____exports.musashi_ganryuu_jima = __TS__Class()
local musashi_ganryuu_jima = ____exports.musashi_ganryuu_jima
musashi_ganryuu_jima.name = "musashi_ganryuu_jima"
__TS__ClassExtends(musashi_ganryuu_jima, BaseAbility)
function musashi_ganryuu_jima.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_01"
    self.DashPosition = Vector(0, 0, 0)
    self.SlashPosition = Vector(0, 0, 0)
    self.SecondSlashPosition = Vector(0, 0, 0)
end
function musashi_ganryuu_jima.prototype.OnVectorCastStart(self, vStartLocation, vDirection)
    self.Caster = self:GetCaster()
    self:SetVector(vStartLocation, vDirection)
    local DashCounter = self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ganryuu_jima.name, {undefined = undefined})
    DashCounter:IncrementStackCount()
    EmitGlobalSound(self.SoundVoiceline)
end
function musashi_ganryuu_jima.prototype.SetVector(self, vStartLocation, vDirection)
    self.DashPosition = vStartLocation
    self.SlashPosition = vDirection
    self.SecondSlashPosition = vDirection:__unm()
end
function musashi_ganryuu_jima.prototype.GetCastRange(self)
    if IsServer() then
        return 0
    else
        return self:GetSpecialValueFor("SlashRange")
    end
end
function musashi_ganryuu_jima.prototype.GetVectorTargetRange(self)
    return self:GetSpecialValueFor("SlashRange")
end
function musashi_ganryuu_jima.prototype.GetVectorTargetStartRadius(self)
    return self:GetSpecialValueFor("SlashRadius")
end
function musashi_ganryuu_jima.prototype.GetVectorTargetEndRadius(self)
    return self:GetSpecialValueFor("SlashRadius")
end
function musashi_ganryuu_jima.prototype.GetVectorPosition(self)
    return self.DashPosition
end
function musashi_ganryuu_jima.prototype.GetVectorDirection(self)
    return self.SlashPosition
end
function musashi_ganryuu_jima.prototype.GetVector2Position(self)
    return self.SlashPosition
end
function musashi_ganryuu_jima.prototype.UpdateVectorValues(self)
end
function musashi_ganryuu_jima.prototype.IsDualVectorDirection(self)
    return false
end
function musashi_ganryuu_jima.prototype.IgnoreVectorArrowWidth(self)
    return false
end
musashi_ganryuu_jima = __TS__Decorate(
    {registerAbility(nil)},
    musashi_ganryuu_jima
)
____exports.musashi_ganryuu_jima = musashi_ganryuu_jima
____exports.musashi_modifier_ganryuu_jima = __TS__Class()
local musashi_modifier_ganryuu_jima = ____exports.musashi_modifier_ganryuu_jima
musashi_modifier_ganryuu_jima.name = "musashi_modifier_ganryuu_jima"
__TS__ClassExtends(musashi_modifier_ganryuu_jima, BaseModifier)
function musashi_modifier_ganryuu_jima.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.DashPosition = Vector(0, 0, 0)
    self.SlashPosition = Vector(0, 0, 0)
    self.SecondSlashPosition = Vector(0, 0, 0)
end
function musashi_modifier_ganryuu_jima.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ganryuu_Jima = self:GetAbility()
    self.DashPosition = self.Ganryuu_Jima.DashPosition
    self.SlashPosition = self.Ganryuu_Jima.SlashPosition
    self.SecondSlashPosition = self.Ganryuu_Jima.SecondSlashPosition
    giveUnitDataDrivenModifier(self.Caster, self.Caster, "pause_sealdisabled", 1.5)
end
function musashi_modifier_ganryuu_jima.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    local Position = Vector(0, 0, 0)
    repeat
        local ____switch67 = stackCount
        local ____cond67 = ____switch67 == 0
        if ____cond67 then
            do
                Position = self.DashPosition
                local ____opt_39 = self.Caster
                local DashBuff = ____opt_39 and ____opt_39:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_43 = DashBuff.TargetPoint
                local ____opt_41 = self.Caster
                ____DashBuff_TargetPoint_43.z = ____opt_41 and ____opt_41:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_46 = DashBuff.TargetPoint
                local ____opt_44 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_46 - (____opt_44 and ____opt_44:GetAbsOrigin())):Normalized()
                local ____opt_47 = self.Caster
                if ____opt_47 ~= nil then
                    ____opt_47:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
                end
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond67 = ____cond67 or ____switch67 == 1
        if ____cond67 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond67 = ____cond67 or ____switch67 == 2
        if ____cond67 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond67 = ____cond67 or ____switch67 == 3
        if ____cond67 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_49 = self.Caster
        local SlashBuff = ____opt_49 and ____opt_49:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        local ____opt_51 = self.Caster
        if ____opt_51 ~= nil then
            ____opt_51:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 2)
        end
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_53 = self.Caster
    if ____opt_53 ~= nil then
        ____opt_53:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____opt_55 = self.Caster
    if ____opt_55 ~= nil then
        ____opt_55:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    local ____opt_57 = self.Caster
    if ____opt_57 ~= nil then
        ____opt_57:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    local ____opt_59 = self.Caster
    if ____opt_59 ~= nil then
        ____opt_59:SetForwardVector(self.Caster:GetForwardVector() * 10)
    end
    local ____FindClearSpaceForUnit_64 = FindClearSpaceForUnit
    local ____self_Caster_63 = self.Caster
    local ____opt_61 = self.Caster
    ____FindClearSpaceForUnit_64(
        ____self_Caster_63,
        ____opt_61 and ____opt_61:GetAbsOrigin(),
        true
    )
    local ____opt_65 = self.Caster
    if ____opt_65 ~= nil then
        ____opt_65:AddNewModifier(self.Caster, self.Ganryuu_Jima, "modifier_phase", {duration = 1.5})
    end
end
function musashi_modifier_ganryuu_jima.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ganryuu_jima = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima
)
____exports.musashi_modifier_ganryuu_jima = musashi_modifier_ganryuu_jima
____exports.musashi_modifier_ganryuu_jima_slash = __TS__Class()
local musashi_modifier_ganryuu_jima_slash = ____exports.musashi_modifier_ganryuu_jima_slash
musashi_modifier_ganryuu_jima_slash.name = "musashi_modifier_ganryuu_jima_slash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_slash, BaseModifier)
function musashi_modifier_ganryuu_jima_slash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundSfx = "musashi_ganryuu_jima_sfx"
    self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    self.StartPosition = Vector(0, 0, 0)
    self.EndPosition = Vector(0, 0, 0)
    self.TargetPoint = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    self.StartPosition = self.Caster:GetAbsOrigin()
    local ____opt_67 = self.Ability
    self.SlashRange = ____opt_67 and ____opt_67:GetSpecialValueFor("SlashRange")
    self.Caster:EmitSound(self.SoundSfx)
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_69 = self.Caster
    if ____opt_69 ~= nil then
        ____opt_69:SetForwardVector(self.TargetPoint)
    end
    local ____opt_71 = self.Caster
    local CurrentOrigin = ____opt_71 and ____opt_71:GetAbsOrigin()
    local ____opt_73 = self.Ability
    local DashSpeed = ____opt_73 and ____opt_73:GetSpecialValueFor("DashSpeed")
    local ____opt_75 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_75 and ____opt_75:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_77 = self.Caster
    if ____opt_77 ~= nil then
        ____opt_77:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_79 = self.Caster
    self.EndPosition = ____opt_79 and ____opt_79:GetAbsOrigin()
    self:CreateParticle()
    self:DoDamage()
    local ____opt_81 = self.Caster
    local DashCounter = ____opt_81 and ____opt_81:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    DashCounter:IncrementStackCount()
end
function musashi_modifier_ganryuu_jima_slash.prototype.DoDamage(self)
    local ____FindUnitsInLine_94 = FindUnitsInLine
    local ____opt_83 = self.Caster
    local ____array_93 = __TS__SparseArrayNew(
        ____opt_83 and ____opt_83:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_85 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_85 and ____opt_85:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_87 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_87 and ____opt_87:GetAbilityTargetTeam()
    )
    local ____opt_89 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_89 and ____opt_89:GetAbilityTargetType()
    )
    local ____opt_91 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_91 and ____opt_91:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_94(__TS__SparseArraySpread(____array_93))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_98 = ApplyDamage
        local ____self_Caster_97 = self.Caster
        local ____opt_95 = self.Ability
        ____ApplyDamage_98({
            victim = Iterator,
            attacker = ____self_Caster_97,
            damage = ____opt_95 and ____opt_95:GetSpecialValueFor("DmgPerSlash"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
        local ____opt_99 = self.Caster
        if ____opt_99 and ____opt_99:HasModifier(____exports.musashi_modifier_tengan.name) then
            local ____Iterator_AddNewModifier_104 = Iterator.AddNewModifier
            local ____array_103 = __TS__SparseArrayNew(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name)
            local ____opt_101 = self.Ability
            __TS__SparseArrayPush(
                ____array_103,
                {duration = ____opt_101 and ____opt_101:GetSpecialValueFor("DmgDelay")}
            )
            ____Iterator_AddNewModifier_104(
                Iterator,
                __TS__SparseArraySpread(____array_103)
            )
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ____opt_105 = self.Caster
    if ____opt_105 and ____opt_105:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    ParticleManager:SetParticleControl(ParticleId, 0, self.StartPosition)
    ParticleManager:SetParticleControl(ParticleId, 1, self.EndPosition)
end
function musashi_modifier_ganryuu_jima_slash.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return ModifierTable
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsHidden(self)
    return true
end
musashi_modifier_ganryuu_jima_slash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_slash
)
____exports.musashi_modifier_ganryuu_jima_slash = musashi_modifier_ganryuu_jima_slash
____exports.musashi_modifier_ganryuu_jima_debuff = __TS__Class()
local musashi_modifier_ganryuu_jima_debuff = ____exports.musashi_modifier_ganryuu_jima_debuff
musashi_modifier_ganryuu_jima_debuff.name = "musashi_modifier_ganryuu_jima_debuff"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_debuff, BaseModifier)
function musashi_modifier_ganryuu_jima_debuff.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf"
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Victim = self:GetParent()
    self:CreateParticle()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:DoDamage()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.DoDamage(self)
    local ____opt_107 = self.Caster
    local ModifierTengan = ____opt_107 and ____opt_107:FindModifierByName(____exports.musashi_modifier_tengan.name)
    ApplyDamage({
        victim = self.Victim,
        attacker = self.Caster,
        damage = ModifierTengan.BonusDmg,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self:GetAbility()
    })
end
function musashi_modifier_ganryuu_jima_debuff.prototype.CreateParticle(self)
    local ____opt_109 = self.Caster
    if ____opt_109 and ____opt_109:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_unique.vpcf"
    end
    local DebuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Victim)
    self:AddParticle(
        DebuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsDebuff(self)
    return true
end
musashi_modifier_ganryuu_jima_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_debuff
)
____exports.musashi_modifier_ganryuu_jima_debuff = musashi_modifier_ganryuu_jima_debuff
____exports.musashi_modifier_ganryuu_jima_dash = __TS__Class()
local musashi_modifier_ganryuu_jima_dash = ____exports.musashi_modifier_ganryuu_jima_dash
musashi_modifier_ganryuu_jima_dash.name = "musashi_modifier_ganryuu_jima_dash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_dash, BaseModifier)
function musashi_modifier_ganryuu_jima_dash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.StartPosition = Vector(0, 0, 0)
    self.TargetPoint = Vector(0, 0, 0)
    self.NormalizedTargetPoint = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_111 = self.Caster
    self.StartPosition = ____opt_111 and ____opt_111:GetAbsOrigin()
    local ____opt_113 = self.Ability
    self.SlashRange = ____opt_113 and ____opt_113:GetSpecialValueFor("SlashRange")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_115 = self.Caster
    if ____opt_115 ~= nil then
        ____opt_115:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_117 = self.Caster
    local CurrentOrigin = ____opt_117 and ____opt_117:GetAbsOrigin()
    local ____opt_119 = self.Ability
    local DashSpeed = ____opt_119 and ____opt_119:GetSpecialValueFor("DashSpeed")
    local ____opt_121 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_121 and ____opt_121:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_123 = self.Caster
    if ____opt_123 ~= nil then
        ____opt_123:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_127 = Entities.FindByNameWithin
    local ____opt_125 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_127(
        Entities,
        nil,
        ____opt_125 and ____opt_125:GetName(),
        self.TargetPoint,
        DashSpeed
    )
    if Musashi or self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_128 = self.Caster
    local DashCounter = ____opt_128 and ____opt_128:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if DashCounter ~= nil then
        DashCounter:IncrementStackCount()
    end
end
function musashi_modifier_ganryuu_jima_dash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_dash.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ganryuu_jima_dash.prototype.IsHidden(self)
    return true
end
musashi_modifier_ganryuu_jima_dash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_dash
)
____exports.musashi_modifier_ganryuu_jima_dash = musashi_modifier_ganryuu_jima_dash
____exports.musashi_niou = __TS__Class()
local musashi_niou = ____exports.musashi_niou
musashi_niou.name = "musashi_niou"
__TS__ClassExtends(musashi_niou, BaseAbility)
function musashi_niou.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    self.Niou = CreateUnitByName(
        "musashi_niou",
        self.Caster:GetAbsOrigin(),
        false,
        self.Caster,
        self.Caster,
        self.Caster:GetTeam()
    )
    local ModelScale = self:GetSpecialValueFor("ModelScale")
    self.Niou:SetModelScale(ModelScale)
    self.Niou:AddNewModifier(self.Niou, self, ____exports.musashi_modifier_niou.name, {undefined = undefined})
end
function musashi_niou.prototype.DestroyNiou(self, delay)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_132 = self.Niou
        if ____opt_132 ~= nil then
            ____opt_132:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_134 = self.Niou
        if ____opt_134 ~= nil then
            ____opt_134:Destroy()
        end
    end)
end
musashi_niou = __TS__Decorate(
    {registerAbility(nil)},
    musashi_niou
)
____exports.musashi_niou = musashi_niou
____exports.musashi_modifier_niou = __TS__Class()
local musashi_modifier_niou = ____exports.musashi_modifier_niou
musashi_modifier_niou.name = "musashi_modifier_niou"
__TS__ClassExtends(musashi_modifier_niou, BaseModifier)
function musashi_modifier_niou.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true
    }
    return ModifierTable
end
function musashi_modifier_niou.prototype.IsHidden(self)
    return true
end
function musashi_modifier_niou.prototype.IsPermanent(self)
    return true
end
function musashi_modifier_niou.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_niou = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou
)
____exports.musashi_modifier_niou = musashi_modifier_niou
____exports.musashi_tengen_no_hana = __TS__Class()
local musashi_tengen_no_hana = ____exports.musashi_tengen_no_hana
musashi_tengen_no_hana.name = "musashi_tengen_no_hana"
__TS__ClassExtends(musashi_tengen_no_hana, BaseAbility)
function musashi_tengen_no_hana.prototype.OnSpellStart(self)
    local TengenNoHana = self:GetCaster():FindModifierByName(____exports.musashi_modifier_tengen_no_hana.name)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    if TengenNoHana then
        TengenNoHana:Destroy()
        return
    end
    self:GetCaster():AddNewModifier(
        self:GetCaster(),
        self,
        ____exports.musashi_modifier_tengen_no_hana.name,
        {duration = BuffDuration}
    )
end
musashi_tengen_no_hana = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tengen_no_hana
)
____exports.musashi_tengen_no_hana = musashi_tengen_no_hana
____exports.musashi_modifier_tengen_no_hana = __TS__Class()
local musashi_modifier_tengen_no_hana = ____exports.musashi_modifier_tengen_no_hana
musashi_modifier_tengen_no_hana.name = "musashi_modifier_tengen_no_hana"
__TS__ClassExtends(musashi_modifier_tengen_no_hana, BaseModifier)
function musashi_modifier_tengen_no_hana.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_02"
    self.SoundSfx = "musashi_tengen_no_hana_sfx"
    self.OverheadParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf"
    self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_basic.vpcf"
    self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_basic.vpcf"
    self.DmgOutputPercentage = 0
    self.Radius = 0
end
function musashi_modifier_tengen_no_hana.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_136 = self.Ability
    self.Radius = ____opt_136 and ____opt_136:GetSpecialValueFor("Radius")
    self:CreateParticle()
    local ____opt_138 = self.Caster
    if ____opt_138 ~= nil then
        ____opt_138:EmitSound(self.SoundSfx)
    end
    self:StartIntervalThink(1)
end
function musashi_modifier_tengen_no_hana.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
end
function musashi_modifier_tengen_no_hana.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    repeat
        local ____switch131 = stackCount
        local ____cond131 = ____switch131 == 0
        if ____cond131 then
            do
                self.DmgOutputPercentage = 0.25
                break
            end
        end
        ____cond131 = ____cond131 or ____switch131 == 1
        if ____cond131 then
            do
                self.DmgOutputPercentage = 0.5
                break
            end
        end
        ____cond131 = ____cond131 or ____switch131 == 2
        if ____cond131 then
            do
                self.DmgOutputPercentage = 1
                self:Destroy()
                break
            end
        end
    until true
end
function musashi_modifier_tengen_no_hana.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_140 = self.Caster
    if ____opt_140 ~= nil then
        ____opt_140:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    EmitGlobalSound(self.SoundVoiceline)
    self:CreateAoeParticle()
    self:DoDamage()
    local ____opt_142 = self.Caster
    if ____opt_142 ~= nil then
        ____opt_142:SwapAbilities(____exports.musashi_tengen_no_hana.name, ____exports.musashi_mukyuu.name, false, true)
    end
end
function musashi_modifier_tengen_no_hana.prototype.DoDamage(self)
    local ____FindUnitsInRadius_155 = FindUnitsInRadius
    local ____opt_144 = self.Caster
    local ____array_154 = __TS__SparseArrayNew(____opt_144 and ____opt_144:GetTeam())
    local ____opt_146 = self.Caster
    __TS__SparseArrayPush(
        ____array_154,
        ____opt_146 and ____opt_146:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_148 = self.Ability
    __TS__SparseArrayPush(
        ____array_154,
        ____opt_148 and ____opt_148:GetAbilityTargetTeam()
    )
    local ____opt_150 = self.Ability
    __TS__SparseArrayPush(
        ____array_154,
        ____opt_150 and ____opt_150:GetAbilityTargetType()
    )
    local ____opt_152 = self.Ability
    __TS__SparseArrayPush(
        ____array_154,
        ____opt_152 and ____opt_152:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_155(__TS__SparseArraySpread(____array_154))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_159 = ApplyDamage
        local ____self_Caster_158 = self.Caster
        local ____opt_156 = self.Ability
        ____ApplyDamage_159({
            victim = Iterator,
            attacker = ____self_Caster_158,
            damage = (____opt_156 and ____opt_156:GetSpecialValueFor("Dmg")) * self.DmgOutputPercentage,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ____opt_160 = self.Caster
    if ____opt_160 and ____opt_160:HasModifier("modifier_ascended") then
        self.OverheadParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique1.vpcf"
    end
    local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    self:AddParticle(
        OverheadParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_tengen_no_hana.prototype.CreateAoeParticle(self)
    local ____opt_162 = self.Caster
    if ____opt_162 and ____opt_162:HasModifier("modifier_ascended") then
        self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
    end
    local AoeParticle = ParticleManager:CreateParticle(self.AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local AoeMarkerParticle = ParticleManager:CreateParticle(self.AoeMarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_166 = ParticleManager.SetParticleControl
    local ____opt_164 = self.Caster
    ____ParticleManager_SetParticleControl_166(
        ParticleManager,
        AoeParticle,
        0,
        ____opt_164 and ____opt_164:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        AoeParticle,
        2,
        Vector(self.Radius, self.Radius, self.Radius)
    )
    ParticleManager:SetParticleControl(
        AoeMarkerParticle,
        2,
        Vector(self.Radius, self.Radius, self.Radius)
    )
end
function musashi_modifier_tengen_no_hana.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengen_no_hana.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tengen_no_hana = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengen_no_hana
)
____exports.musashi_modifier_tengen_no_hana = musashi_modifier_tengen_no_hana
____exports.musashi_mukyuu = __TS__Class()
local musashi_mukyuu = ____exports.musashi_mukyuu
musashi_mukyuu.name = "musashi_mukyuu"
__TS__ClassExtends(musashi_mukyuu, BaseAbility)
function musashi_mukyuu.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_03"
    self.SoundSfx = "musashi_mukyuu_sfx"
end
function musashi_mukyuu.prototype.OnSpellStart(self)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    self.Caster = self:GetCaster()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_mukyuu.name, {duration = BuffDuration})
    self:PlaySound()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_mukyuu_slot_checker.name, {duration = 10})
    self.Caster:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, false, true)
end
function musashi_mukyuu.prototype.PlaySound(self)
    local ____opt_167 = self.Caster
    if ____opt_167 ~= nil then
        ____opt_167:EmitSound(self.SoundVoiceline)
    end
    local ____opt_169 = self.Caster
    if ____opt_169 ~= nil then
        ____opt_169:EmitSound(self.SoundSfx)
    end
end
musashi_mukyuu = __TS__Decorate(
    {registerAbility(nil)},
    musashi_mukyuu
)
____exports.musashi_mukyuu = musashi_mukyuu
____exports.musashi_modifier_mukyuu = __TS__Class()
local musashi_modifier_mukyuu = ____exports.musashi_modifier_mukyuu
musashi_modifier_mukyuu.name = "musashi_modifier_mukyuu"
__TS__ClassExtends(musashi_modifier_mukyuu, BaseModifier)
function musashi_modifier_mukyuu.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_mukyuu_basic.vpcf"
end
function musashi_modifier_mukyuu.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    self:CreateParticle()
end
function musashi_modifier_mukyuu.prototype.OnDestroy(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        if not IsServer() then
            return ____awaiter_resolve(nil)
        end
        __TS__Await(Sleep(nil, 5))
        local ____opt_171 = self.Caster
        if ____opt_171 ~= nil then
            ____opt_171:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, true, false)
        end
    end)
end
function musashi_modifier_mukyuu.prototype.CreateParticle(self)
    local ____opt_173 = self.Caster
    if ____opt_173 and ____opt_173:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_mukyuu_unique.vpcf"
        local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            ParticleId,
            1,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        self:AddParticle(
            ParticleId,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            ParticleId,
            0,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        ParticleManager:SetParticleControl(
            ParticleId,
            1,
            Vector(150, 0, 0)
        )
        self:AddParticle(
            ParticleId,
            false,
            false,
            -1,
            false,
            false
        )
    end
end
function musashi_modifier_mukyuu.prototype.CheckState(self)
    local ModifierTable = {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return ModifierTable
end
function musashi_modifier_mukyuu.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE}
end
function musashi_modifier_mukyuu.prototype.GetAbsoluteNoDamagePure(self)
    return 1
end
function musashi_modifier_mukyuu.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_mukyuu.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_mukyuu = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_mukyuu
)
____exports.musashi_modifier_mukyuu = musashi_modifier_mukyuu
____exports.musashi_mukyuu_slot_checker = __TS__Class()
local musashi_mukyuu_slot_checker = ____exports.musashi_mukyuu_slot_checker
musashi_mukyuu_slot_checker.name = "musashi_mukyuu_slot_checker"
__TS__ClassExtends(musashi_mukyuu_slot_checker, BaseModifier)
function musashi_mukyuu_slot_checker.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.MukyuuIndex = 0
end
function musashi_mukyuu_slot_checker.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    local ____opt_175 = self:GetAbility()
    self.MukyuuIndex = ____opt_175 and ____opt_175:GetAbilityIndex()
end
function musashi_mukyuu_slot_checker.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_179 = self:GetCaster()
    local ____opt_177 = ____opt_179 and ____opt_179:FindAbilityByName(____exports.musashi_mukyuu.name)
    local MukyuuCurrentIndex = ____opt_177 and ____opt_177:GetAbilityIndex()
    if MukyuuCurrentIndex ~= self.MukyuuIndex then
        local ____opt_181 = self:GetCaster()
        if ____opt_181 ~= nil then
            ____opt_181:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, true, false)
        end
    end
end
function musashi_mukyuu_slot_checker.prototype.IsPurgable(self)
    return false
end
function musashi_mukyuu_slot_checker.prototype.IsPurgeException(self)
    return false
end
function musashi_mukyuu_slot_checker.prototype.IsHidden(self)
    return true
end
musashi_mukyuu_slot_checker = __TS__Decorate(
    {registerModifier(nil)},
    musashi_mukyuu_slot_checker
)
____exports.musashi_mukyuu_slot_checker = musashi_mukyuu_slot_checker
return ____exports
