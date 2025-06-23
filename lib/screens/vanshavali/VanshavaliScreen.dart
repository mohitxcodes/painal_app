import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'package:painal/models/FamilyMember.dart';

class FamilyMember {
  final int id;
  final String name;
  final String hindiName;
  final String birthYear;
  final List<int> children;
  final int? parentId;
  final String profilePhoto;
  List<FamilyMember> childMembers = [];

  FamilyMember({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.birthYear,
    required this.children,
    this.parentId,
    required this.profilePhoto,
  });
}

final List<FamilyMember> flatFamilyData = [
  FamilyMember(
    id: 100,
    name: "Rampay Thakur",
    hindiName: "रामपे ठाकुर",
    birthYear: "Unavailable",
    children: [101],
    profilePhoto: "",
  ),
  FamilyMember(
    id: 101,
    name: "Teka Shahi",
    hindiName: "टेका शाही",
    birthYear: "Unavailable",
    children: [102, 103],
    parentId: 100,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 102,
    name: "Jeevadhar Shahi",
    hindiName: "जीवधर शाही",
    birthYear: "Unavailable",
    children: [104],
    parentId: 101,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 103,
    name: "Paradhar Shahi",
    hindiName: "पराधर शाही",
    birthYear: "Unavailable",
    children: [],
    parentId: 101,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 104,
    name: "Choudhary Gopal Singh",
    hindiName: "चौधरी गोपाल सिंह",
    birthYear: "Unavailable",
    children: [105, 106],
    parentId: 102,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 105,
    name: "Anu Singh",
    hindiName: "अनु सिंह",
    birthYear: "Unavailable",
    children: [107, 108, 109, 110],
    parentId: 104,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 106,
    name: "Ratan Singh",
    hindiName: "रतन सिंह",
    birthYear: "Unavailable",
    children: [111, 112, 113, 114],
    parentId: 104,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 107,
    name: "Roop Ray",
    hindiName: "रूप राय",
    birthYear: "Unavailable",
    children: [115, 116],
    parentId: 105,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 108,
    name: "Laachi Ray",
    hindiName: "लाछी राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 105,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 109,
    name: "Bheali Ray",
    hindiName: "भेली राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 105,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 110,
    name: "Jay Shee Ray",
    hindiName: "जय शी राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 105,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 111,
    name: "Veerbal Singh",
    hindiName: "वीरबल सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 106,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 112,
    name: "Adhivaran Singh",
    hindiName: "अधिवरण सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 106,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 113,
    name: "Girdhar Singh",
    hindiName: "गिरधर सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 106,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 114,
    name: "Puran Singh",
    hindiName: "पूरण सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 106,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 115,
    name: "Shiv Raj Ray",
    hindiName: "शिव राज राय",
    birthYear: "Unavailable",
    children: [117, 118],
    parentId: 107,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 116,
    name: "Phool Ray",
    hindiName: "फूल राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 107,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 117,
    name: "Khemi Ray",
    hindiName: "खेमी राय",
    birthYear: "Unavailable",
    children: [119, 120, 121],
    parentId: 115,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 118,
    name: "Rajdev Ray",
    hindiName: "राजदेव राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 115,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 119,
    name: "Dalel Ray",
    hindiName: "दलेल राय",
    birthYear: "Unavailable",
    children: [122, 123],
    parentId: 117,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 120,
    name: "Himanchal Ray",
    hindiName: "हिमांचल राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 117,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 121,
    name: "Dheena Ray",
    hindiName: "धीना राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 117,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 122,
    name: "Shiv Sahay Singh",
    hindiName: "शिव सहाय सिंह",
    birthYear: "Unavailable",
    children: [124, 125, 126, 127],
    parentId: 119,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 123,
    name: "Jeeta Singh",
    hindiName: "जीता सिंह",
    birthYear: "Unavailable",
    children: [151, 152, 153, 157, 176],
    parentId: 119,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 124,
    name: "Cheta Singh",
    hindiName: "चेता सिंह",
    birthYear: "Unavailable",
    children: [128],
    parentId: 122,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 125,
    name: "Dharichan Singh",
    hindiName: "धरिचन सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 122,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 126,
    name: "Bharosi Singh",
    hindiName: "भरोसी सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 122,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 127,
    name: "Badar Singh",
    hindiName: "बदर सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 122,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 128,
    name: "Hiaawal Singh",
    hindiName: "हियावल सिंह",
    birthYear: "Unavailable",
    children: [129, 130, 131, 132],
    parentId: 124,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 129,
    name: "Ajgayvi Singh",
    hindiName: "अजगयवी सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 128,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 130,
    name: "Ramdeni Singh",
    hindiName: "रामदेनी सिंह",
    birthYear: "Unavailable",
    children: [133],
    parentId: 128,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 131,
    name: "Triveni Singh",
    hindiName: "त्रिवेणी सिंह",
    birthYear: "Unavailable",
    children: [140],
    parentId: 128,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 132,
    name: "Shivdeni Singh",
    hindiName: "शिवदेनी सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 128,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 133,
    name: "Shrikrishan Singh",
    hindiName: "श्रीकृष्ण सिंह",
    birthYear: "Unavailable",
    children: [134, 135, 136],
    parentId: 130,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 134,
    name: "Hari Shankar Singh",
    hindiName: "हरी शंकर सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 133,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 135,
    name: "Uma Shankar Singh",
    hindiName: "उमा शंकर सिंह",
    birthYear: "Unavailable",
    children: [137],
    parentId: 133,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 136,
    name: "Rama Shankar Singh",
    hindiName: "रमा शंकर सिंह",
    birthYear: "Unavailable",
    children: [138],
    parentId: 133,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 137,
    name: "Ravikant",
    hindiName: "रविकांत",
    birthYear: "Unavailable",
    children: [139],
    parentId: 135,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 138,
    name: "Nandan",
    hindiName: "नंदन",
    birthYear: "Unavailable",
    children: [],
    parentId: 136,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 139,
    name: "Ishan",
    hindiName: "ईशान",
    birthYear: "Unavailable",
    children: [],
    parentId: 137,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 140,
    name: "Deepnath Singh",
    hindiName: "दीपनाथ सिंह",
    birthYear: "Unavailable",
    children: [141],
    parentId: 131,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 141,
    name: "Ram Karan Singh",
    hindiName: "राम करन सिंह",
    birthYear: "Unavailable",
    children: [142, 145, 147, 150],
    parentId: 140,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 142,
    name: "Shree Ram Singh",
    hindiName: "श्री राम सिंह",
    birthYear: "Unavailable",
    children: [143],
    parentId: 141,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 143,
    name: "Nagendar Singh",
    hindiName: "नगेन्द्र सिंह",
    birthYear: "Unavailable",
    children: [144],
    parentId: 142,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 144,
    name: "Priyanshu",
    hindiName: "प्रियांशु",
    birthYear: "Unavailable",
    children: [],
    parentId: 143,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 145,
    name: "Baliram Singh",
    hindiName: "बलीराम सिंह",
    birthYear: "Unavailable",
    children: [146],
    parentId: 141,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 146,
    name: "Anku Kumar",
    hindiName: "अंकु कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 145,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 147,
    name: "Ramnarayan Singh",
    hindiName: "रामनारायण सिंह",
    birthYear: "Unavailable",
    children: [148, 149],
    parentId: 141,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 148,
    name: "Bittu Kumar",
    hindiName: "बिट्टू कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 147,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 149,
    name: "Sagar Kumar",
    hindiName: "सागर कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 147,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 150,
    name: "Manoj Singh",
    hindiName: "मनोज सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 141,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 151,
    name: "Khuba Singh",
    hindiName: "खुबा सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 123,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 152,
    name: "Sharan Singh",
    hindiName: "शरण सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 123,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 153,
    name: "Nandlal Singh",
    hindiName: "नंदलाल सिंह",
    birthYear: "Unavailable",
    children: [154, 155],
    parentId: 123,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 154,
    name: "Gunja Singh",
    hindiName: "गुंजा सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 153,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 155,
    name: "Chhedi Singh",
    hindiName: "छेदी सिंह",
    birthYear: "Unavailable",
    children: [156],
    parentId: 153,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 156,
    name: "Karmu Singh",
    hindiName: "कर्मू सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 155,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 157,
    name: "Deena Singh",
    hindiName: "दिना सिंह",
    birthYear: "Unavailable",
    children: [158, 159, 160],
    parentId: 123,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 158,
    name: "Man Bahal Singh",
    hindiName: "मन बहाल सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 157,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 159,
    name: "Darawat Singh",
    hindiName: "दरावत सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 157,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 160,
    name: "Nakhid Singh",
    hindiName: "नखीद सिंह",
    birthYear: "Unavailable",
    children: [161, 171, 177],
    parentId: 157,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 161,
    name: "Ganga Prasad Singh",
    hindiName: "गंगा प्रसाद सिंह",
    birthYear: "Unavailable",
    children: [162, 166],
    parentId: 160,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 162,
    name: "Maha Sundar Devi",
    hindiName: "महासुंदर देवी",
    birthYear: "Unavailable",
    children: [163],
    parentId: 161,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 163,
    name: "Bhola Singh",
    hindiName: "भोला सिंह",
    birthYear: "Unavailable",
    children: [164, 165],
    parentId: 162,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 164,
    name: "Ajit Kumar",
    hindiName: "अजीत कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 163,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 165,
    name: "Ajay Kumar",
    hindiName: "अजय कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 163,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 166,
    name: "Mundar Devi",
    hindiName: "मुंदर देवी",
    birthYear: "Unavailable",
    children: [167, 168, 169, 170],
    parentId: 161,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 167,
    name: "Shree Ram Singh",
    hindiName: "श्री राम सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 166,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 168,
    name: "Kamta Singh",
    hindiName: "कमता सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 166,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 169,
    name: "Vidyanand Singh",
    hindiName: "विद्यानंद सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 166,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 170,
    name: "Suryadev Singh",
    hindiName: "सूर्यदेव सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 166,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 171,
    name: "Yamuna Prasad Singh",
    hindiName: "यमुना प्रसाद सिंह",
    birthYear: "Unavailable",
    children: [172],
    parentId: 160,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 172,
    name: "Bajrangi Singh",
    hindiName: "बजरंगी सिंह",
    birthYear: "Unavailable",
    children: [173],
    parentId: 171,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 173,
    name: "Krishna Murari Singh",
    hindiName: "कृष्ण मुरारी सिंह",
    birthYear: "Unavailable",
    children: [174],
    parentId: 172,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 174,
    name: "Kamlesh Singh",
    hindiName: "कमलेश सिंह",
    birthYear: "Unavailable",
    children: [175],
    parentId: 173,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 175,
    name: "Amit",
    hindiName: "अमित",
    birthYear: "Unavailable",
    children: [],
    parentId: 174,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 176,
    name: "Teni Singh",
    hindiName: "टेनी सिंह",
    birthYear: "Unavailable",
    children: [193, 194, 195, 196],
    parentId: 123,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 177,
    name: "Beni Prasad Singh",
    hindiName: "बेनी प्रसाद सिंह",
    birthYear: "Unavailable",
    children: [178, 179, 180],
    parentId: 160,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 178,
    name: "Inder Singh",
    hindiName: "इंदर सिंह",
    birthYear: "Unavailable",
    children: [181],
    parentId: 177,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 179,
    name: "Kumha Singh",
    hindiName: "कुम्हा सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 177,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 180,
    name: "Ramdev Singh",
    hindiName: "रामदेव सिंह",
    birthYear: "Unavailable",
    children: [190, 187, 188],
    parentId: 177,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 181,
    name: "Kamdev Singh",
    hindiName: "कमदेव सिंह",
    birthYear: "Unavailable",
    children: [182, 183],
    parentId: 178,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 182,
    name: "Ramesh Singh",
    hindiName: "रमेश सिंह",
    birthYear: "Unavailable",
    children: [184],
    parentId: 181,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 183,
    name: "Bhushan Singh",
    hindiName: "भूषण सिंह",
    birthYear: "Unavailable",
    children: [185, 186],
    parentId: 181,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 184,
    name: "Atul Kumar",
    hindiName: "अतुल कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 182,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 185,
    name: "Sandeep Kumar",
    hindiName: "संदीप कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 183,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 186,
    name: "Puspak Kumar",
    hindiName: "पुष्पक कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 183,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 187,
    name: "Anil Singh",
    hindiName: "अनिल सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 180,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 188,
    name: "Sunil Singh",
    hindiName: "सुनील सिंह",
    birthYear: "Unavailable",
    children: [189],
    parentId: 180,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 189,
    name: "Prince Kumar",
    hindiName: "प्रिंस कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 188,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 190,
    name: "Sudhir Singh",
    hindiName: "सुधीर सिंह",
    birthYear: "Unavailable",
    children: [191, 192],
    parentId: 180,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 191,
    name: "Priyanshu",
    hindiName: "प्रियांशु",
    birthYear: "Unavailable",
    children: [],
    parentId: 190,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 192,
    name: "Divayanshu",
    hindiName: "दिव्यांशु",
    birthYear: "Unavailable",
    children: [],
    parentId: 190,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 193,
    name: "Kishan Singh",
    hindiName: "किशन सिंह",
    birthYear: "Unavailable",
    children: [197],
    parentId: 176,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 194,
    name: "Cheeri Singh",
    hindiName: "चेरी सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 176,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 195,
    name: "Doma Singh",
    hindiName: "डोमा सिंह",
    birthYear: "Unavailable",
    children: [204],
    parentId: 176,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 196,
    name: "Rakdu Singh",
    hindiName: "रकडू सिंह",
    birthYear: "Unavailable",
    children: [213],
    parentId: 176,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 197,
    name: "Kalika Singh",
    hindiName: "कालीका सिंह",
    birthYear: "Unavailable",
    children: [198],
    parentId: 193,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 198,
    name: "Kripal Singh",
    hindiName: "कृपाल सिंह",
    birthYear: "Unavailable",
    children: [199],
    parentId: 197,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 199,
    name: "Parshuram Singh",
    hindiName: "परशुराम सिंह",
    birthYear: "Unavailable",
    children: [200, 201, 202],
    parentId: 198,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 200,
    name: "Arun",
    hindiName: "अरुण",
    birthYear: "Unavailable",
    children: [203],
    parentId: 199,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 201,
    name: "Sanjay",
    hindiName: "संजय",
    birthYear: "Unavailable",
    children: [],
    parentId: 199,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 202,
    name: "Ranjeet",
    hindiName: "रंजीत",
    birthYear: "Unavailable",
    children: [],
    parentId: 199,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 203,
    name: "Deepak",
    hindiName: "दीपक",
    birthYear: "Unavailable",
    children: [],
    parentId: 200,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 204,
    name: "Jagat Singh",
    hindiName: "जगत सिंह",
    birthYear: "Unavailable",
    children: [205],
    parentId: 195,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 205,
    name: "Ramashray Singh",
    hindiName: "रामश्रय सिंह",
    birthYear: "Unavailable",
    children: [206, 207, 208, 209],
    parentId: 204,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 206,
    name: "Naresh Singh",
    hindiName: "नरेश सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 205,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 207,
    name: "Ganesh Singh",
    hindiName: "गणेश सिंह",
    birthYear: "Unavailable",
    children: [210, 211],
    parentId: 205,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 208,
    name: "Ramji Singh",
    hindiName: "रामजी सिंह",
    birthYear: "Unavailable",
    children: [212],
    parentId: 205,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 209,
    name: "Laxman Singh",
    hindiName: "लक्ष्मण सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 205,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 210,
    name: "Subash",
    hindiName: "सुबाष",
    birthYear: "Unavailable",
    children: [],
    parentId: 207,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 211,
    name: "Suvansh",
    hindiName: "सुवंश",
    birthYear: "Unavailable",
    children: [],
    parentId: 207,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 212,
    name: "Shiv Kumar",
    hindiName: "शिव कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 208,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 213,
    name: "Harihar Singh",
    hindiName: "हरिहर सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 196,
    profilePhoto: "",
  ),
];

// Future<List<FamilyMember>> fetchFamilyMembers() async {
//   final snapshot =
//       await FirebaseFirestore.instance
//           .collection('familyMembers')
//           .orderBy('id') // Optional: for sorted results
//           .get();

//   return snapshot.docs.map((doc) => FamilyMember.fromMap(doc.data())).toList();
// }

FamilyMember? buildFamilyTreeFromFlatData(
  List<FamilyMember> flatData,
  int rootId,
) {
  final Map<int, FamilyMember> memberMap = {for (var m in flatData) m.id: m};
  for (var member in flatData) {
    member.childMembers = member.children.map((id) => memberMap[id]!).toList();
  }
  return memberMap[rootId];
}

// Build the tree structure before using it
void _prepareFamilyTree() {
  for (var root in flatFamilyData.where((m) => m.parentId == null)) {
    buildFamilyTreeFromFlatData(flatFamilyData, root.id);
  }
}

class VanshavaliScreen extends StatefulWidget {
  const VanshavaliScreen({super.key});

  @override
  State<VanshavaliScreen> createState() => _VanshavaliScreenState();
}

class _VanshavaliScreenState extends State<VanshavaliScreen> {
  late FamilyMember _currentMember;
  final List<FamilyMember> _navigationStack = [];

  @override
  void initState() {
    super.initState();
    _prepareFamilyTree();
    _currentMember = flatFamilyData.firstWhere((m) => m.parentId == null);
  }

  void _navigateToChild(FamilyMember child) {
    setState(() {
      _navigationStack.add(_currentMember);
      _currentMember = child;
    });
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _currentMember = _navigationStack.removeLast();
      });
    }
  }

  void _navigateToMember(FamilyMember member) {
    // Build the navigation stack to this member
    List<FamilyMember> stack = [];
    FamilyMember? current = member;
    while (current?.parentId != null) {
      final parent = flatFamilyData.firstWhere(
        (m) => m.id == current!.parentId,
        orElse: () => current!,
      );
      if (parent.id == current!.id) break;
      stack.insert(0, parent);
      current = parent;
    }
    setState(() {
      _navigationStack
        ..clear()
        ..addAll(stack);
      _currentMember = member;
    });
  }

  void _showSearchDialog() async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        String query = '';
        List<FamilyMember> results = [];
        return StatefulBuilder(
          builder: (context, setState) {
            void updateResults(String value) {
              setState(() {
                query = value;
                if (query.isEmpty) {
                  results = [];
                } else {
                  results =
                      flatFamilyData
                          .where(
                            (m) =>
                                m.name.toLowerCase().contains(
                                  query.toLowerCase(),
                                ) ||
                                m.hindiName.contains(query),
                          )
                          .toList();
                }
              });
            }

            Widget _highlightText(
              String text,
              String query, {
              TextStyle? style,
              TextStyle? highlightStyle,
            }) {
              if (query.isEmpty) return Text(text, style: style);
              final lower = text.toLowerCase();
              final lowerQuery = query.toLowerCase();
              final spans = <TextSpan>[];
              int start = 0;
              int idx;
              while ((idx = lower.indexOf(lowerQuery, start)) != -1) {
                if (idx > start) {
                  spans.add(
                    TextSpan(text: text.substring(start, idx), style: style),
                  );
                }
                spans.add(
                  TextSpan(
                    text: text.substring(idx, idx + query.length),
                    style:
                        highlightStyle ??
                        const TextStyle(
                          backgroundColor: Color(0x33FFEB3B),
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
                start = idx + query.length;
              }
              if (start < text.length) {
                spans.add(TextSpan(text: text.substring(start), style: style));
              }
              return RichText(text: TextSpan(children: spans));
            }

            return Stack(
              children: [
                // Blur background
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.transparent),
                ),
                Center(
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    insetPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green.withOpacity(0.4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                          maxHeight: 440,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Search by name...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 14,
                                            ),
                                        isDense: true,
                                      ),
                                      onChanged: updateResults,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child:
                                    query.isEmpty
                                        ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.family_restroom,
                                                color: Colors.green[200],
                                                size: 48,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Start typing to search for a family member',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : results.isEmpty
                                        ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.grey[400],
                                                size: 40,
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'No family members found',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : ListView.separated(
                                          itemCount: results.length,
                                          separatorBuilder:
                                              (_, __) => const Divider(
                                                height: 1,
                                                color: Color(0xFFE0E0E0),
                                              ),
                                          itemBuilder: (context, idx) {
                                            final member = results[idx];
                                            final parent =
                                                member.parentId != null
                                                    ? flatFamilyData.firstWhere(
                                                      (m) =>
                                                          m.id ==
                                                          member.parentId,
                                                      orElse:
                                                          () => FamilyMember(
                                                            id: -1,
                                                            name: 'No parent',
                                                            hindiName: '',
                                                            birthYear: '',
                                                            children: [],
                                                            profilePhoto: '',
                                                          ),
                                                    )
                                                    : null;
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.green[100],
                                                backgroundImage:
                                                    member
                                                            .profilePhoto
                                                            .isNotEmpty
                                                        ? NetworkImage(
                                                          member.profilePhoto,
                                                        )
                                                        : null,
                                                child:
                                                    member.profilePhoto.isEmpty
                                                        ? const Icon(
                                                          Icons.person,
                                                          color: Colors.green,
                                                        )
                                                        : null,
                                              ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _highlightText(
                                                    member.name,
                                                    query,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  _highlightText(
                                                    member.hindiName,
                                                    query,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle:
                                                  parent != null &&
                                                          parent.id != -1
                                                      ? Text(
                                                        'Parent: ${parent.name}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                        ),
                                                      )
                                                      : const Text(
                                                        'No parent',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                _navigateToMember(member);
                                              },
                                            );
                                          },
                                        ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                bottom: 10,
                                top: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Material(
                                    color: Colors.green[700],
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 3),
                                            const Text(
                                              'Close',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMembers = flatFamilyData.length;
    final totalGenerations = _calculateGenerations();
    final double horizontalPadding =
        12 + 12; // from EdgeInsets.fromLTRB(12, ...)
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(240),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vanshavali - Family Tree',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'वंशावली - परिवार वृक्ष',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                                letterSpacing: 0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Explore your family lineage and discover connections across generations. Use the search to quickly find any member.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Text(
                        'Total Members: ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$totalMembers',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        'Generations: ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$totalGenerations',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.green,
                          size: 26,
                        ),
                        onPressed: _showSearchDialog,
                        tooltip: 'Search Family Member',
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double contentWidth = screenWidth - horizontalPadding;
          final double maxContentWidth = 900;
          final double cardWidth =
              contentWidth > maxContentWidth ? maxContentWidth : contentWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: screenWidth, // Take full width for centering
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width: cardWidth,
                    margin: const EdgeInsets.only(top: 8, bottom: 18),
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      10,
                      10,
                      20,
                    ), // extra bottom padding for navigation button
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.green[200]!, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, innerConstraints) {
                        final contentInnerWidth = innerConstraints.maxWidth;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_navigationStack.isNotEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: _navigateBack,
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black87,
                                  ),
                                  label: const Text(
                                    'Back',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                            // Main member card always full width
                            SizedBox(
                              width: contentInnerWidth,
                              child: _familyMemberCard(_currentMember),
                            ),
                            if (_currentMember.childMembers.isNotEmpty) ...[
                              // Draw vertical line
                              Container(
                                width: 2,
                                height: 32,
                                color: Colors.green[200],
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                              // Children row scrollable inside the bordered area
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      _currentMember.childMembers.map((child) {
                                        return Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            _familyMemberCard(child),
                                            Positioned(
                                              child:
                                                  child.childMembers.isNotEmpty
                                                      ? Material(
                                                        color:
                                                            Colors.green[700],
                                                        shape:
                                                            const CircleBorder(),
                                                        child: InkWell(
                                                          customBorder:
                                                              const CircleBorder(),
                                                          onTap:
                                                              () =>
                                                                  _navigateToChild(
                                                                    child,
                                                                  ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  6.0,
                                                                ),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      : Material(
                                                        color: Colors.red[200],
                                                        shape:
                                                            const CircleBorder(),
                                                        child: InkWell(
                                                          customBorder:
                                                              const CircleBorder(),
                                                          onTap: () {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'No children for this member.',
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          2,
                                                                    ),
                                                              ),
                                                            );
                                                          }, // Disabled navigation
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  6.0,
                                                                ),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _familyMemberCard(FamilyMember member) {
    return GestureDetector(
      onTap: () => _showMemberDetails(member),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[1],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.green[100]!, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.green[100],
                backgroundImage:
                    member.profilePhoto.isNotEmpty
                        ? NetworkImage(member.profilePhoto)
                        : null,
                child:
                    member.profilePhoto.isEmpty
                        ? const Icon(
                          Icons.person,
                          color: Colors.green,
                          size: 24,
                        )
                        : null,
              ),
              const SizedBox(height: 10),
              Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Text(
                member.hindiName,
                style: const TextStyle(fontSize: 13, color: Colors.green),
              ),
              Text(
                'Born: ${member.birthYear}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 18), // Space for navigation button
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDetails(FamilyMember member) {
    final parent =
        member.parentId != null
            ? flatFamilyData.firstWhere(
              (m) => m.id == member.parentId,
              orElse: () => member,
            )
            : null;
    final children = member.childMembers;
    final siblings =
        member.parentId != null
            ? flatFamilyData
                .where(
                  (m) => m.parentId == member.parentId && m.id != member.id,
                )
                .toList()
            : <FamilyMember>[];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.green[100],
                            backgroundImage:
                                member.profilePhoto.isNotEmpty
                                    ? NetworkImage(member.profilePhoto)
                                    : null,
                            child:
                                member.profilePhoto.isEmpty
                                    ? const Icon(
                                      Icons.person,
                                      color: Colors.green,
                                      size: 28,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  member.hindiName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'जन्म वर्ष: ${member.birthYear}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (parent != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parent:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _memberMiniCard(parent),
                            const SizedBox(height: 16),
                          ],
                        ),
                      if (siblings.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Siblings:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: siblings.map(_memberMiniCard).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      if (children.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Children:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: children.map(_memberMiniCard).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _memberMiniCard(FamilyMember member) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.green[100],
          backgroundImage:
              member.profilePhoto.isNotEmpty
                  ? NetworkImage(member.profilePhoto)
                  : null,
          child:
              member.profilePhoto.isEmpty
                  ? const Icon(Icons.person, color: Colors.green, size: 18)
                  : null,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            Text(
              member.hindiName,
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  int _calculateGenerations() {
    // Implementation of _calculateGenerations method
    // This is a placeholder and should be replaced with the actual implementation
    return 0; // Placeholder return, actual implementation needed
  }
}
