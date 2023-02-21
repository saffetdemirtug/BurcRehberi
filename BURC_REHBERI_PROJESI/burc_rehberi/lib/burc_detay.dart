import 'package:burc_rehberi/model/burc.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
//AppBar rengini, kullanılan resim renginden türetmek istediğim için hazır "palette generator" isimli paket kullanıldı.

class BurcDetay extends StatefulWidget {
  final Burc secilenBurc;
  const BurcDetay({required this.secilenBurc, super.key});

  @override
  State<BurcDetay> createState() => _BurcDetayState();
}

class _BurcDetayState extends State<BurcDetay> {
  Color appbarRengi = Colors.transparent;
  late PaletteGenerator
      _generator; //renk türetmek,future ifade ettiği için late kullanıldı.

  @override
  void initState() {
    //Build'den önce,yani kullanıcı widget'ı görmeden önce appbar rengi belirlenmesi gerektiği için initState çağırıldı.Her burcun detay sayfasına erişilmeye çalıştığında initState yalnızca bir kere çağrılıp çalıştırılacak.Bu da appbar rengini kullanıcı görmeden önce oluşturup appbar renk işlemini bitirecek.Tekrar tekrar built ile tetiklenmeyecektir.
    super.initState();
    appbarRenginiOlustur();
    
    //Eğer ki future ifade eden appbarRenginiOlustur fonksiyonu performans arttırmak için en son çağrılmak istenirse WidgetsBinding.instance.addPostFrameCallback((_) => appbarRenginiOlustur()); ifadesi eklenerek önce verileri hazır olan built çalışacak ve en son appbarRenginiOlustur() fonksiyonu çalışacaktır.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          backgroundColor: appbarRengi,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              widget.secilenBurc.burcAdi + " Burcu ve Özellikleri",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            background: Image.asset(
              "images/" + widget.secilenBurc.burcBuyukResim,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Text(
                widget.secilenBurc.burcDetayi,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        )
      ],
    ));
  }

  void appbarRenginiOlustur() async {
    _generator = await PaletteGenerator.fromImageProvider(
        AssetImage("images/" + widget.secilenBurc.burcBuyukResim));
    appbarRengi = _generator.vibrantColor!.color;
    setState(
        () {}); //Her burç sayfası için appbar rengi yeniden türetilecektir. Her türetilen yeni renkten build'i haberdar edip build methodunun her yeni renkte tetiklenmesi için setState kullanıldı.
  }
}
