import 'package:flutter/material.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier{
  String _categorySelectedEng = 'none';
  String _categorySelectedKor = '선택';

  get categorySelectedEng => _categorySelectedEng;
  get categorySelectedKor => _categorySelectedKor;
  get categoryEng => _categoryKorisKey;
  get categoryKor => _categoryEngisKey;

  void setKorSelected(String categor){
    if(_categoryEngisKey.values.contains(categor)){
      _categorySelectedKor = categor;
      notifyListeners();
    }
  }
  void setEngSelected(String categor) {
    if (_categoryKorisKey.values.contains(categor)) {
      _categorySelectedEng = categor;
      notifyListeners();
    }
  }
}

Map<String, dynamic> _categoryKorisKey = {
  '선택':'none',
  '가구':'furniture',
  '전자기기':'electronics',
  '유아동':'kids',
  '스포츠':'sports',
  '메이크업':'makeup',
  '남성':'men',
  '여성':'women'
};

Map<String, dynamic> _categoryEngisKey = {
 'none': '선택',
 'furniture': '가구',
 'electronics': '전자기기',
 'kids': '유아동',
 'sports': '스포츠',
 'makeup': '메이크업',
 'men': '남성',
 'women': '여성'
};