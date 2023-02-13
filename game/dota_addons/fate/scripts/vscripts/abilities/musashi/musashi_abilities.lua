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
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 1,["14"] = 1,["15"] = 1,["16"] = 1,["17"] = 1,["18"] = 2,["19"] = 2,["20"] = 4,["21"] = 9,["22"] = 10,["23"] = 9,["24"] = 10,["26"] = 10,["27"] = 12,["28"] = 13,["29"] = 9,["30"] = 17,["31"] = 19,["32"] = 20,["33"] = 21,["34"] = 22,["35"] = 17,["36"] = 25,["37"] = 27,["39"] = 27,["41"] = 28,["43"] = 28,["45"] = 25,["46"] = 10,["47"] = 9,["48"] = 10,["50"] = 10,["51"] = 32,["52"] = 33,["53"] = 32,["54"] = 33,["56"] = 33,["57"] = 35,["58"] = 36,["59"] = 37,["60"] = 42,["61"] = 43,["62"] = 32,["63"] = 45,["64"] = 47,["65"] = 48,["66"] = 48,["67"] = 49,["68"] = 49,["69"] = 51,["72"] = 56,["73"] = 57,["74"] = 45,["75"] = 60,["76"] = 62,["77"] = 60,["78"] = 65,["79"] = 67,["80"] = 67,["81"] = 69,["82"] = 70,["83"] = 71,["85"] = 74,["86"] = 75,["87"] = 76,["88"] = 77,["89"] = 77,["90"] = 77,["91"] = 77,["92"] = 77,["93"] = 77,["94"] = 77,["95"] = 77,["96"] = 77,["97"] = 80,["98"] = 80,["99"] = 80,["100"] = 80,["101"] = 80,["102"] = 80,["103"] = 80,["104"] = 80,["105"] = 80,["106"] = 82,["107"] = 82,["108"] = 82,["109"] = 82,["110"] = 82,["111"] = 82,["112"] = 82,["113"] = 82,["114"] = 83,["115"] = 83,["116"] = 83,["117"] = 83,["118"] = 83,["119"] = 83,["120"] = 83,["121"] = 83,["122"] = 84,["123"] = 84,["124"] = 84,["125"] = 84,["126"] = 84,["127"] = 84,["128"] = 84,["129"] = 84,["130"] = 65,["131"] = 87,["132"] = 89,["133"] = 87,["134"] = 92,["135"] = 94,["136"] = 92,["137"] = 97,["138"] = 99,["139"] = 97,["140"] = 102,["141"] = 104,["142"] = 102,["143"] = 107,["144"] = 109,["145"] = 107,["146"] = 33,["147"] = 32,["148"] = 33,["150"] = 33,["151"] = 116,["152"] = 117,["153"] = 116,["154"] = 117,["156"] = 117,["157"] = 119,["158"] = 120,["159"] = 116,["160"] = 124,["161"] = 126,["162"] = 127,["163"] = 128,["165"] = 128,["167"] = 129,["168"] = 124,["169"] = 132,["170"] = 134,["172"] = 134,["174"] = 135,["176"] = 135,["178"] = 132,["179"] = 117,["180"] = 116,["181"] = 117,["183"] = 117,["184"] = 139,["185"] = 140,["186"] = 139,["187"] = 140,["189"] = 140,["190"] = 142,["191"] = 143,["192"] = 148,["193"] = 139,["194"] = 150,["195"] = 152,["198"] = 157,["199"] = 158,["200"] = 159,["201"] = 159,["202"] = 160,["203"] = 150,["204"] = 163,["205"] = 165,["208"] = 170,["209"] = 163,["210"] = 173,["211"] = 175,["212"] = 175,["213"] = 177,["214"] = 178,["215"] = 179,["216"] = 180,["217"] = 180,["218"] = 180,["219"] = 180,["220"] = 180,["221"] = 180,["222"] = 180,["223"] = 180,["225"] = 184,["226"] = 185,["227"] = 185,["228"] = 185,["229"] = 185,["230"] = 185,["231"] = 185,["232"] = 185,["233"] = 185,["234"] = 185,["235"] = 187,["236"] = 187,["237"] = 187,["238"] = 187,["239"] = 187,["240"] = 187,["241"] = 187,["242"] = 187,["244"] = 190,["245"] = 191,["246"] = 191,["247"] = 191,["248"] = 191,["249"] = 191,["250"] = 191,["251"] = 191,["252"] = 191,["253"] = 173,["254"] = 194,["255"] = 196,["256"] = 194,["257"] = 199,["258"] = 201,["259"] = 199,["260"] = 140,["261"] = 139,["262"] = 140,["264"] = 140,["265"] = 208,["266"] = 209,["267"] = 208,["268"] = 209,["270"] = 209,["271"] = 211,["272"] = 212,["273"] = 214,["274"] = 220,["275"] = 221,["276"] = 222,["277"] = 223,["278"] = 208,["279"] = 225,["280"] = 227,["281"] = 228,["282"] = 229,["283"] = 230,["284"] = 231,["285"] = 232,["287"] = 232,["289"] = 233,["290"] = 225,["291"] = 236,["292"] = 238,["294"] = 238,["296"] = 236,["297"] = 241,["298"] = 243,["299"] = 244,["301"] = 244,["303"] = 245,["304"] = 246,["305"] = 247,["306"] = 241,["307"] = 250,["308"] = 252,["309"] = 254,["310"] = 255,["311"] = 256,["312"] = 257,["314"] = 260,["315"] = 250,["316"] = 263,["317"] = 265,["318"] = 266,["319"] = 268,["320"] = 270,["322"] = 270,["325"] = 274,["327"] = 274,["330"] = 263,["331"] = 278,["332"] = 280,["333"] = 280,["334"] = 280,["335"] = 280,["336"] = 280,["337"] = 280,["338"] = 280,["339"] = 280,["340"] = 280,["341"] = 280,["342"] = 280,["343"] = 280,["344"] = 280,["345"] = 283,["346"] = 285,["347"] = 287,["348"] = 287,["349"] = 287,["350"] = 287,["351"] = 287,["352"] = 287,["353"] = 285,["355"] = 298,["356"] = 299,["357"] = 299,["358"] = 301,["359"] = 303,["360"] = 305,["361"] = 307,["362"] = 307,["363"] = 307,["364"] = 307,["365"] = 307,["366"] = 307,["367"] = 305,["369"] = 318,["371"] = 278,["372"] = 322,["373"] = 324,["374"] = 324,["375"] = 326,["376"] = 327,["378"] = 329,["379"] = 331,["382"] = 333,["383"] = 334,["387"] = 337,["390"] = 339,["391"] = 340,["395"] = 343,["398"] = 345,["399"] = 346,["403"] = 349,["406"] = 351,["407"] = 352,["412"] = 357,["413"] = 358,["414"] = 359,["415"] = 360,["416"] = 360,["417"] = 360,["418"] = 360,["419"] = 360,["420"] = 361,["421"] = 361,["422"] = 361,["423"] = 361,["424"] = 361,["425"] = 362,["427"] = 366,["428"] = 367,["429"] = 368,["430"] = 368,["431"] = 368,["432"] = 368,["433"] = 368,["434"] = 369,["435"] = 369,["436"] = 369,["437"] = 369,["438"] = 369,["440"] = 322,["441"] = 373,["442"] = 375,["444"] = 375,["446"] = 373,["447"] = 378,["448"] = 380,["449"] = 378,["450"] = 209,["451"] = 208,["452"] = 209,["454"] = 209,["455"] = 387,["456"] = 388,["457"] = 387,["458"] = 388,["460"] = 388,["461"] = 390,["462"] = 394,["463"] = 395,["464"] = 396,["465"] = 387,["466"] = 398,["467"] = 400,["468"] = 401,["469"] = 402,["470"] = 403,["471"] = 404,["472"] = 398,["473"] = 407,["474"] = 409,["475"] = 410,["476"] = 411,["477"] = 407,["478"] = 414,["479"] = 416,["480"] = 418,["482"] = 422,["484"] = 414,["485"] = 426,["486"] = 428,["487"] = 426,["488"] = 431,["489"] = 433,["490"] = 431,["491"] = 436,["492"] = 438,["493"] = 436,["494"] = 441,["495"] = 443,["496"] = 441,["497"] = 446,["498"] = 448,["499"] = 446,["500"] = 451,["501"] = 453,["502"] = 451,["503"] = 456,["504"] = 456,["505"] = 461,["506"] = 463,["507"] = 461,["508"] = 466,["509"] = 468,["510"] = 466,["511"] = 388,["512"] = 387,["513"] = 388,["515"] = 388,["516"] = 472,["517"] = 473,["518"] = 472,["519"] = 473,["521"] = 473,["522"] = 478,["523"] = 479,["524"] = 480,["525"] = 472,["526"] = 482,["527"] = 484,["530"] = 489,["531"] = 490,["532"] = 491,["533"] = 492,["534"] = 493,["535"] = 494,["536"] = 482,["537"] = 497,["538"] = 499,["541"] = 504,["543"] = 506,["544"] = 508,["547"] = 510,["548"] = 511,["549"] = 511,["550"] = 513,["551"] = 514,["552"] = 514,["553"] = 514,["554"] = 515,["555"] = 515,["556"] = 515,["557"] = 516,["559"] = 516,["561"] = 517,["565"] = 520,["568"] = 522,["572"] = 525,["575"] = 527,["579"] = 531,["582"] = 533,["587"] = 538,["588"] = 540,["589"] = 540,["590"] = 542,["591"] = 543,["593"] = 543,["595"] = 544,["597"] = 497,["598"] = 548,["599"] = 550,["602"] = 555,["604"] = 555,["606"] = 556,["608"] = 556,["610"] = 557,["612"] = 557,["614"] = 558,["616"] = 558,["618"] = 559,["619"] = 559,["620"] = 559,["621"] = 559,["622"] = 559,["623"] = 559,["624"] = 559,["625"] = 559,["626"] = 560,["628"] = 560,["630"] = 548,["631"] = 563,["632"] = 565,["633"] = 563,["634"] = 568,["635"] = 570,["636"] = 568,["637"] = 473,["638"] = 472,["639"] = 473,["641"] = 473,["642"] = 574,["643"] = 575,["644"] = 574,["645"] = 575,["647"] = 575,["648"] = 577,["649"] = 579,["650"] = 584,["651"] = 585,["652"] = 586,["653"] = 588,["654"] = 589,["655"] = 574,["656"] = 591,["657"] = 593,["660"] = 598,["661"] = 599,["662"] = 600,["663"] = 601,["664"] = 601,["665"] = 602,["666"] = 591,["667"] = 605,["668"] = 607,["671"] = 612,["673"] = 612,["675"] = 613,["676"] = 613,["677"] = 614,["678"] = 614,["679"] = 615,["680"] = 615,["681"] = 616,["682"] = 617,["684"] = 617,["686"] = 619,["687"] = 621,["689"] = 605,["690"] = 625,["691"] = 627,["694"] = 632,["695"] = 632,["696"] = 633,["697"] = 634,["698"] = 635,["699"] = 635,["700"] = 636,["701"] = 625,["702"] = 639,["703"] = 641,["704"] = 641,["706"] = 641,["707"] = 641,["708"] = 641,["709"] = 641,["711"] = 642,["714"] = 642,["716"] = 642,["719"] = 642,["721"] = 643,["724"] = 643,["726"] = 643,["729"] = 643,["731"] = 641,["732"] = 645,["733"] = 647,["734"] = 651,["735"] = 652,["736"] = 647,["737"] = 649,["738"] = 649,["739"] = 649,["740"] = 649,["741"] = 649,["742"] = 649,["743"] = 647,["744"] = 659,["745"] = 659,["746"] = 661,["747"] = 661,["748"] = 661,["751"] = 661,["753"] = 661,["754"] = 661,["755"] = 661,["756"] = 661,["759"] = 639,["760"] = 666,["761"] = 668,["762"] = 668,["763"] = 670,["765"] = 673,["766"] = 674,["767"] = 675,["768"] = 666,["769"] = 678,["770"] = 680,["771"] = 681,["772"] = 681,["773"] = 681,["774"] = 681,["775"] = 681,["776"] = 681,["777"] = 681,["778"] = 690,["779"] = 678,["780"] = 693,["781"] = 695,["782"] = 693,["783"] = 698,["784"] = 700,["785"] = 698,["786"] = 703,["787"] = 705,["788"] = 703,["789"] = 575,["790"] = 574,["791"] = 575,["793"] = 575,["794"] = 709,["795"] = 710,["796"] = 709,["797"] = 710,["799"] = 710,["800"] = 712,["801"] = 709,["802"] = 718,["803"] = 720,["806"] = 725,["807"] = 726,["808"] = 727,["809"] = 718,["810"] = 730,["811"] = 732,["814"] = 737,["815"] = 730,["816"] = 740,["817"] = 742,["820"] = 747,["821"] = 740,["822"] = 750,["823"] = 752,["824"] = 752,["825"] = 754,["826"] = 756,["827"] = 756,["828"] = 756,["829"] = 756,["830"] = 756,["831"] = 756,["832"] = 754,["833"] = 750,["834"] = 767,["835"] = 769,["836"] = 769,["837"] = 771,["839"] = 774,["840"] = 775,["841"] = 775,["842"] = 775,["843"] = 775,["844"] = 775,["845"] = 775,["846"] = 775,["847"] = 775,["848"] = 767,["849"] = 778,["850"] = 780,["851"] = 778,["852"] = 783,["853"] = 785,["854"] = 783,["855"] = 788,["856"] = 790,["857"] = 788,["858"] = 710,["859"] = 709,["860"] = 710,["862"] = 710,["863"] = 794,["864"] = 795,["865"] = 794,["866"] = 795,["868"] = 795,["869"] = 797,["870"] = 798,["871"] = 799,["872"] = 804,["873"] = 805,["874"] = 794,["875"] = 807,["876"] = 809,["879"] = 814,["880"] = 815,["881"] = 816,["882"] = 816,["883"] = 817,["884"] = 817,["885"] = 807,["886"] = 820,["887"] = 822,["890"] = 827,["892"] = 827,["894"] = 828,["895"] = 828,["896"] = 829,["897"] = 829,["898"] = 830,["899"] = 830,["900"] = 831,["901"] = 832,["903"] = 832,["905"] = 833,["906"] = 833,["907"] = 833,["908"] = 833,["909"] = 833,["910"] = 833,["911"] = 833,["912"] = 833,["913"] = 833,["914"] = 835,["915"] = 837,["917"] = 820,["918"] = 841,["919"] = 843,["922"] = 848,["923"] = 848,["924"] = 849,["925"] = 849,["927"] = 841,["928"] = 852,["929"] = 854,["930"] = 852,["931"] = 857,["932"] = 859,["933"] = 857,["934"] = 862,["935"] = 864,["936"] = 862,["937"] = 795,["938"] = 794,["939"] = 795,["941"] = 795,["942"] = 871,["943"] = 872,["944"] = 871,["945"] = 872,["946"] = 877,["947"] = 879,["948"] = 880,["949"] = 880,["950"] = 880,["951"] = 880,["952"] = 880,["953"] = 880,["954"] = 880,["955"] = 880,["956"] = 881,["957"] = 882,["958"] = 883,["959"] = 877,["960"] = 886,["962"] = 888,["964"] = 888,["966"] = 889,["967"] = 890,["969"] = 890,["972"] = 886,["973"] = 872,["974"] = 871,["975"] = 872,["977"] = 872,["978"] = 894,["979"] = 895,["980"] = 894,["981"] = 895,["982"] = 897,["983"] = 899,["984"] = 900,["985"] = 900,["986"] = 900,["987"] = 900,["988"] = 900,["989"] = 900,["990"] = 900,["991"] = 900,["992"] = 910,["993"] = 897,["994"] = 913,["995"] = 915,["996"] = 913,["997"] = 918,["998"] = 920,["999"] = 918,["1000"] = 923,["1001"] = 925,["1002"] = 923,["1003"] = 928,["1004"] = 930,["1005"] = 928,["1006"] = 895,["1007"] = 894,["1008"] = 895,["1010"] = 895,["1011"] = 937,["1012"] = 938,["1013"] = 937,["1014"] = 938,["1015"] = 940,["1016"] = 942,["1017"] = 942,["1018"] = 943,["1019"] = 945,["1020"] = 947,["1023"] = 951,["1025"] = 951,["1026"] = 951,["1027"] = 951,["1028"] = 951,["1029"] = 951,["1030"] = 951,["1032"] = 940,["1033"] = 938,["1034"] = 937,["1035"] = 938,["1037"] = 938,["1038"] = 955,["1039"] = 956,["1040"] = 955,["1041"] = 956,["1043"] = 956,["1044"] = 958,["1045"] = 959,["1046"] = 961,["1047"] = 962,["1048"] = 963,["1049"] = 967,["1050"] = 968,["1051"] = 955,["1052"] = 970,["1053"] = 972,["1056"] = 977,["1057"] = 978,["1058"] = 979,["1059"] = 979,["1060"] = 980,["1061"] = 981,["1063"] = 981,["1065"] = 982,["1066"] = 970,["1067"] = 985,["1068"] = 987,["1071"] = 992,["1072"] = 985,["1073"] = 995,["1074"] = 997,["1078"] = 1002,["1079"] = 1004,["1082"] = 1006,["1086"] = 1009,["1089"] = 1011,["1093"] = 1014,["1096"] = 1016,["1097"] = 1017,["1102"] = 995,["1103"] = 1023,["1104"] = 1025,["1107"] = 1030,["1109"] = 1030,["1111"] = 1031,["1112"] = 1032,["1113"] = 1033,["1114"] = 1034,["1116"] = 1034,["1118"] = 1023,["1119"] = 1037,["1120"] = 1039,["1121"] = 1039,["1122"] = 1039,["1123"] = 1039,["1126"] = 1039,["1127"] = 1039,["1128"] = 1039,["1130"] = 1040,["1133"] = 1040,["1135"] = 1040,["1138"] = 1040,["1140"] = 1041,["1143"] = 1041,["1145"] = 1041,["1147"] = 1039,["1148"] = 1042,["1149"] = 1044,["1150"] = 1048,["1151"] = 1049,["1152"] = 1044,["1153"] = 1046,["1154"] = 1046,["1155"] = 1046,["1156"] = 1046,["1157"] = 1046,["1158"] = 1046,["1159"] = 1044,["1161"] = 1037,["1162"] = 1058,["1163"] = 1060,["1164"] = 1060,["1165"] = 1062,["1167"] = 1065,["1168"] = 1066,["1169"] = 1066,["1170"] = 1066,["1171"] = 1066,["1172"] = 1066,["1173"] = 1066,["1174"] = 1066,["1175"] = 1066,["1176"] = 1058,["1177"] = 1069,["1178"] = 1071,["1179"] = 1071,["1180"] = 1073,["1181"] = 1074,["1183"] = 1077,["1184"] = 1078,["1185"] = 1079,["1186"] = 1079,["1187"] = 1079,["1188"] = 1079,["1189"] = 1079,["1190"] = 1079,["1191"] = 1079,["1192"] = 1079,["1193"] = 1080,["1194"] = 1080,["1195"] = 1080,["1196"] = 1080,["1197"] = 1080,["1198"] = 1081,["1199"] = 1081,["1200"] = 1081,["1201"] = 1081,["1202"] = 1081,["1203"] = 1069,["1204"] = 1084,["1205"] = 1086,["1206"] = 1084,["1207"] = 1089,["1208"] = 1091,["1209"] = 1089,["1210"] = 956,["1211"] = 955,["1212"] = 956,["1214"] = 956,["1215"] = 1098,["1216"] = 1099,["1217"] = 1098,["1218"] = 1099,["1220"] = 1099,["1221"] = 1101,["1222"] = 1102,["1223"] = 1098,["1224"] = 1106,["1225"] = 1108,["1226"] = 1109,["1227"] = 1110,["1228"] = 1112,["1229"] = 1113,["1230"] = 1114,["1231"] = 1106,["1232"] = 1117,["1233"] = 1119,["1235"] = 1119,["1237"] = 1120,["1239"] = 1120,["1241"] = 1117,["1242"] = 1099,["1243"] = 1098,["1244"] = 1099,["1246"] = 1099,["1247"] = 1124,["1248"] = 1125,["1249"] = 1124,["1250"] = 1125,["1252"] = 1125,["1253"] = 1127,["1254"] = 1124,["1255"] = 1132,["1256"] = 1134,["1259"] = 1139,["1260"] = 1140,["1261"] = 1141,["1262"] = 1132,["1263"] = 1144,["1265"] = 1146,["1268"] = 1151,["1269"] = 1152,["1271"] = 1152,["1274"] = 1144,["1275"] = 1155,["1276"] = 1157,["1277"] = 1157,["1278"] = 1159,["1279"] = 1160,["1280"] = 1161,["1281"] = 1161,["1282"] = 1161,["1283"] = 1161,["1284"] = 1161,["1285"] = 1161,["1286"] = 1161,["1287"] = 1161,["1288"] = 1161,["1289"] = 1163,["1290"] = 1163,["1291"] = 1163,["1292"] = 1163,["1293"] = 1163,["1294"] = 1163,["1295"] = 1163,["1296"] = 1163,["1298"] = 1167,["1299"] = 1168,["1300"] = 1168,["1301"] = 1168,["1302"] = 1168,["1303"] = 1168,["1304"] = 1168,["1305"] = 1168,["1306"] = 1168,["1307"] = 1168,["1308"] = 1170,["1309"] = 1170,["1310"] = 1170,["1311"] = 1170,["1312"] = 1170,["1313"] = 1171,["1314"] = 1171,["1315"] = 1171,["1316"] = 1171,["1317"] = 1171,["1318"] = 1171,["1319"] = 1171,["1320"] = 1171,["1322"] = 1155,["1323"] = 1175,["1324"] = 1177,["1325"] = 1183,["1326"] = 1175,["1327"] = 1186,["1328"] = 1188,["1329"] = 1186,["1330"] = 1191,["1331"] = 1193,["1332"] = 1191,["1333"] = 1196,["1334"] = 1198,["1335"] = 1196,["1336"] = 1201,["1337"] = 1203,["1338"] = 1201,["1339"] = 1125,["1340"] = 1124,["1341"] = 1125,["1343"] = 1125,["1344"] = 1207,["1345"] = 1208,["1346"] = 1207,["1347"] = 1208,["1349"] = 1208,["1350"] = 1210,["1351"] = 1207,["1352"] = 1212,["1353"] = 1214,["1356"] = 1219,["1357"] = 1219,["1358"] = 1212,["1359"] = 1222,["1360"] = 1224,["1363"] = 1229,["1364"] = 1229,["1365"] = 1229,["1366"] = 1231,["1367"] = 1233,["1369"] = 1233,["1372"] = 1222,["1373"] = 1237,["1374"] = 1239,["1375"] = 1237,["1376"] = 1242,["1377"] = 1244,["1378"] = 1242,["1379"] = 1247,["1380"] = 1249,["1381"] = 1247,["1382"] = 1208,["1383"] = 1207,["1384"] = 1208,["1386"] = 1208,["1387"] = 1256,["1388"] = 1257,["1389"] = 1256,["1390"] = 1257,["1391"] = 1259,["1392"] = 1261,["1393"] = 1259,["1394"] = 1257,["1395"] = 1256,["1396"] = 1257,["1398"] = 1257,["1399"] = 1265,["1400"] = 1266,["1401"] = 1265,["1402"] = 1266,["1403"] = 1271,["1404"] = 1273,["1407"] = 1278,["1408"] = 1279,["1409"] = 1271,["1410"] = 1282,["1411"] = 1284,["1414"] = 1289,["1415"] = 1289,["1417"] = 1289,["1418"] = 1289,["1420"] = 1289,["1421"] = 1292,["1422"] = 1292,["1423"] = 1293,["1425"] = 1293,["1427"] = 1294,["1429"] = 1294,["1431"] = 1295,["1433"] = 1282,["1434"] = 1299,["1435"] = 1301,["1436"] = 1299,["1437"] = 1304,["1438"] = 1306,["1439"] = 1304,["1440"] = 1309,["1441"] = 1311,["1442"] = 1309,["1443"] = 1314,["1444"] = 1316,["1445"] = 1314,["1446"] = 1266,["1447"] = 1265,["1448"] = 1266,["1450"] = 1266,["1451"] = 1320,["1452"] = 1321,["1453"] = 1320,["1454"] = 1321,["1456"] = 1321,["1457"] = 1323,["1458"] = 1324,["1459"] = 1326,["1460"] = 1320,["1461"] = 1331,["1462"] = 1333,["1465"] = 1338,["1466"] = 1339,["1467"] = 1340,["1469"] = 1340,["1470"] = 1340,["1471"] = 1340,["1472"] = 1340,["1473"] = 1340,["1474"] = 1340,["1475"] = 1340,["1477"] = 1341,["1478"] = 1342,["1479"] = 1331,["1480"] = 1345,["1481"] = 1347,["1484"] = 1352,["1486"] = 1352,["1487"] = 1352,["1488"] = 1352,["1489"] = 1352,["1490"] = 1352,["1491"] = 1352,["1492"] = 1352,["1494"] = 1345,["1495"] = 1355,["1496"] = 1357,["1498"] = 1357,["1500"] = 1358,["1502"] = 1358,["1504"] = 1355,["1505"] = 1361,["1506"] = 1363,["1507"] = 1363,["1508"] = 1365,["1510"] = 1368,["1511"] = 1369,["1512"] = 1369,["1513"] = 1369,["1514"] = 1369,["1515"] = 1369,["1516"] = 1369,["1517"] = 1369,["1518"] = 1369,["1519"] = 1369,["1520"] = 1371,["1521"] = 1371,["1522"] = 1371,["1523"] = 1371,["1524"] = 1371,["1525"] = 1371,["1526"] = 1371,["1527"] = 1371,["1528"] = 1361,["1529"] = 1374,["1530"] = 1376,["1531"] = 1374,["1532"] = 1379,["1533"] = 1381,["1534"] = 1379,["1535"] = 1384,["1536"] = 1386,["1537"] = 1384,["1538"] = 1389,["1539"] = 1391,["1540"] = 1389,["1541"] = 1321,["1542"] = 1320,["1543"] = 1321,["1545"] = 1321});
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
    self.Ability = self:GetAbility()
    local ____opt_4 = self.Ability
    self.BonusDmg = ____opt_4 and ____opt_4:GetSpecialValueFor("BonusDmg")
    local ____opt_6 = self.Ability
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
        true
    )
    ParticleManager:SetParticleControlEnt(
        RedOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        true
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
    self.Ability = self:GetAbility()
    local ____opt_16 = self.Ability
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
            true
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
        ability = self.Ability
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
    local ____opt_136 = self:GetCaster()
    local TengenNoHana = ____opt_136 and ____opt_136:FindModifierByName(____exports.musashi_modifier_tengen_no_hana.name)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    if TengenNoHana then
        TengenNoHana:Destroy()
        return
    end
    local ____opt_138 = self:GetCaster()
    if ____opt_138 ~= nil then
        ____opt_138:AddNewModifier(
            self:GetCaster(),
            self,
            ____exports.musashi_modifier_tengen_no_hana.name,
            {duration = BuffDuration}
        )
    end
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
    local ____opt_140 = self.Ability
    self.Radius = ____opt_140 and ____opt_140:GetSpecialValueFor("Radius")
    self:CreateParticle()
    local ____opt_142 = self.Caster
    if ____opt_142 ~= nil then
        ____opt_142:EmitSound(self.SoundSfx)
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
    local ____opt_144 = self.Caster
    if ____opt_144 ~= nil then
        ____opt_144:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    EmitGlobalSound(self.SoundVoiceline)
    self:CreateAoeParticle()
    self:DoDamage()
    local ____opt_146 = self.Caster
    if ____opt_146 ~= nil then
        ____opt_146:SwapAbilities(____exports.musashi_tengen_no_hana.name, ____exports.musashi_mukyuu.name, false, true)
    end
end
function musashi_modifier_tengen_no_hana.prototype.DoDamage(self)
    local ____FindUnitsInRadius_159 = FindUnitsInRadius
    local ____opt_148 = self.Caster
    local ____array_158 = __TS__SparseArrayNew(____opt_148 and ____opt_148:GetTeam())
    local ____opt_150 = self.Caster
    __TS__SparseArrayPush(
        ____array_158,
        ____opt_150 and ____opt_150:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_152 = self.Ability
    __TS__SparseArrayPush(
        ____array_158,
        ____opt_152 and ____opt_152:GetAbilityTargetTeam()
    )
    local ____opt_154 = self.Ability
    __TS__SparseArrayPush(
        ____array_158,
        ____opt_154 and ____opt_154:GetAbilityTargetType()
    )
    local ____opt_156 = self.Ability
    __TS__SparseArrayPush(
        ____array_158,
        ____opt_156 and ____opt_156:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_159(__TS__SparseArraySpread(____array_158))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_163 = ApplyDamage
        local ____self_Caster_162 = self.Caster
        local ____opt_160 = self.Ability
        ____ApplyDamage_163({
            victim = Iterator,
            attacker = ____self_Caster_162,
            damage = (____opt_160 and ____opt_160:GetSpecialValueFor("Dmg")) * self.DmgOutputPercentage,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ____opt_164 = self.Caster
    if ____opt_164 and ____opt_164:HasModifier("modifier_ascended") then
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
    local ____opt_166 = self.Caster
    if ____opt_166 and ____opt_166:HasModifier("modifier_ascended") then
        self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
    end
    local AoeParticle = ParticleManager:CreateParticle(self.AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local AoeMarkerParticle = ParticleManager:CreateParticle(self.AoeMarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_170 = ParticleManager.SetParticleControl
    local ____opt_168 = self.Caster
    ____ParticleManager_SetParticleControl_170(
        ParticleManager,
        AoeParticle,
        0,
        ____opt_168 and ____opt_168:GetAbsOrigin()
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
    local ____opt_171 = self.Caster
    if ____opt_171 ~= nil then
        ____opt_171:EmitSound(self.SoundVoiceline)
    end
    local ____opt_173 = self.Caster
    if ____opt_173 ~= nil then
        ____opt_173:EmitSound(self.SoundSfx)
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
        local ____opt_175 = self.Caster
        if ____opt_175 ~= nil then
            ____opt_175:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, true, false)
        end
    end)
end
function musashi_modifier_mukyuu.prototype.CreateParticle(self)
    local ____opt_177 = self.Caster
    if ____opt_177 and ____opt_177:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_mukyuu_unique.vpcf"
        local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            ParticleId,
            1,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            true
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
            true
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
    local ____opt_179 = self:GetAbility()
    self.MukyuuIndex = ____opt_179 and ____opt_179:GetAbilityIndex()
end
function musashi_mukyuu_slot_checker.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_183 = self:GetCaster()
    local ____opt_181 = ____opt_183 and ____opt_183:FindAbilityByName(____exports.musashi_mukyuu.name)
    local MukyuuCurrentIndex = ____opt_181 and ____opt_181:GetAbilityIndex()
    if MukyuuCurrentIndex ~= self.MukyuuIndex then
        local ____opt_185 = self:GetCaster()
        if ____opt_185 ~= nil then
            ____opt_185:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, true, false)
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
____exports.musashi_battle_continuation = __TS__Class()
local musashi_battle_continuation = ____exports.musashi_battle_continuation
musashi_battle_continuation.name = "musashi_battle_continuation"
__TS__ClassExtends(musashi_battle_continuation, BaseAbility)
function musashi_battle_continuation.prototype.GetIntrinsicModifierName(self)
    return ____exports.musashi_modifier_battle_continuation.name
end
musashi_battle_continuation = __TS__Decorate(
    {registerAbility(nil)},
    musashi_battle_continuation
)
____exports.musashi_battle_continuation = musashi_battle_continuation
____exports.musashi_modifier_battle_continuation = __TS__Class()
local musashi_modifier_battle_continuation = ____exports.musashi_modifier_battle_continuation
musashi_modifier_battle_continuation.name = "musashi_modifier_battle_continuation"
__TS__ClassExtends(musashi_modifier_battle_continuation, BaseModifier)
function musashi_modifier_battle_continuation.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
end
function musashi_modifier_battle_continuation.prototype.OnTakeDamage(self)
    if not IsServer() then
        return
    end
    local ____opt_187 = self.Caster
    local ____temp_191 = (____opt_187 and ____opt_187:GetHealth()) <= 0
    if ____temp_191 then
        local ____opt_189 = self.Ability
        ____temp_191 = ____opt_189 and ____opt_189:IsCooldownReady()
    end
    if ____temp_191 then
        local ____opt_192 = self.Ability
        local BuffDuration = ____opt_192 and ____opt_192:GetSpecialValueFor("BuffDuration")
        local ____opt_194 = self.Caster
        if ____opt_194 ~= nil then
            ____opt_194:SetHealth(1)
        end
        local ____opt_196 = self.Caster
        if ____opt_196 ~= nil then
            ____opt_196:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        end
        self.Ability:UseResources(true, false, true)
    end
end
function musashi_modifier_battle_continuation.prototype.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end
function musashi_modifier_battle_continuation.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_battle_continuation.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_battle_continuation.prototype.IsHidden(self)
    return true
end
musashi_modifier_battle_continuation = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_battle_continuation
)
____exports.musashi_modifier_battle_continuation = musashi_modifier_battle_continuation
____exports.musashi_modifier_battle_continuation_active = __TS__Class()
local musashi_modifier_battle_continuation_active = ____exports.musashi_modifier_battle_continuation_active
musashi_modifier_battle_continuation_active.name = "musashi_modifier_battle_continuation_active"
__TS__ClassExtends(musashi_modifier_battle_continuation_active, BaseModifier)
function musashi_modifier_battle_continuation_active.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_04"
    self.SoundSfx = "musashi_battle_continuation_sfx"
    self.ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
end
function musashi_modifier_battle_continuation_active.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_198 = self.Caster
    if ____opt_198 ~= nil then
        ____opt_198:Purge(
            false,
            true,
            false,
            true,
            false
        )
    end
    self:PlaySound()
    self:CreateParticle()
end
function musashi_modifier_battle_continuation_active.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_200 = self.Caster
    if ____opt_200 ~= nil then
        local ____opt_200_Heal_203 = ____opt_200.Heal
        local ____opt_201 = self.Ability
        ____opt_200_Heal_203(
            ____opt_200,
            ____opt_201 and ____opt_201:GetSpecialValueFor("Heal"),
            self.Ability
        )
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_205 = self.Caster
    if ____opt_205 ~= nil then
        ____opt_205:EmitSound(self.SoundVoiceline)
    end
    local ____opt_207 = self.Caster
    if ____opt_207 ~= nil then
        ____opt_207:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ____opt_209 = self.Caster
    if ____opt_209 and ____opt_209:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_battle_continuation_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControlEnt(
        ParticleId,
        5,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0, 0, 0),
        true
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
function musashi_modifier_battle_continuation_active.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_MIN_HEALTH}
end
function musashi_modifier_battle_continuation_active.prototype.GetMinHealth(self)
    return 1
end
function musashi_modifier_battle_continuation_active.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_battle_continuation_active.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_battle_continuation_active = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_battle_continuation_active
)
____exports.musashi_modifier_battle_continuation_active = musashi_modifier_battle_continuation_active
return ____exports
