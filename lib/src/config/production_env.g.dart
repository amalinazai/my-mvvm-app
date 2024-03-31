// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

class _Env {
  static const String BASE_URL = 'https://dummyjson.com';
  static const List<int> _enviedkeyAPI_KEY = [
    2033296581,
    3436264732,
    1970847803,
    2030881830,
    141701897,
    127683929,
    212426316,
    4207568198,
    210641401,
    2786645196,
    3376807836,
    2559567770,
    3557035131,
    330058437,
    3667381390,
    3614322163,
    2105303176,
    423335077,
    654844038,
    1995202339,
    3378963238,
    2864920508,
    3520519592,
    208981207,
    664034121,
    318627999
  ];
  static const List<int> _envieddataAPI_KEY = [
    2033296525,
    3436264793,
    1970847863,
    2030881898,
    141701958,
    127683961,
    212426264,
    4207568142,
    210641328,
    2786645151,
    3376807868,
    2559567827,
    3557035048,
    330058469,
    3667381470,
    3614322081,
    2105303239,
    423335137,
    654844070,
    1995202402,
    3378963318,
    2864920565,
    3520519560,
    208981148,
    664034060,
    318628038
  ];
  static final String API_KEY = String.fromCharCodes(
    List.generate(_envieddataAPI_KEY.length, (i) => i, growable: false)
        .map((i) => _envieddataAPI_KEY[i] ^ _enviedkeyAPI_KEY[i])
        .toList(growable: false),
  );
  static const List<int> _enviedkeyAPI_SECRET = [
    4134886930,
    2303679547,
    3938168550,
    1670204159,
    635796482,
    4210870450,
    1422061063,
    3906066548,
    2938036461,
    1569465799,
    2178704796,
    726992460,
    3414582383,
    3572456680,
    1347432376
  ];
  static const List<int> _envieddataAPI_SECRET = [
    4134886978,
    2303679593,
    3938168489,
    1670204091,
    635796514,
    4210870515,
    1422061143,
    3906066493,
    2938036429,
    1569465748,
    2178704857,
    726992399,
    3414582333,
    3572456621,
    1347432428
  ];
  static final String API_SECRET = String.fromCharCodes(
    List.generate(_envieddataAPI_SECRET.length, (i) => i, growable: false)
        .map((i) => _envieddataAPI_SECRET[i] ^ _enviedkeyAPI_SECRET[i])
        .toList(growable: false),
  );
}
