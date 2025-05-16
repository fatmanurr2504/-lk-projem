Select count(*) as kitapSayisi ,kitapTuru from Kitaplar group by kitapTuru order by kitapSayisi desc


select count(*) as siparisSayisi, k.kullaniciAdi,k.kullaniciSoyadi  from  Siparisler s inner join Kullanicilar k on s.kullaniciID=k.kullaniciID 
group by k.kullaniciAdi,k.kullaniciSoyadi order by siparisSayisi desc


select top 1 sum(siparisFiyat) as siparisFiyat, k.kullaniciAdi,k.kullaniciSoyadi from 
Siparisler s inner join Kullanicilar k 
on s.kullaniciID=k.kullaniciID 
group by k.kullaniciAdi,k.kullaniciSoyadi 
order by siparisFiyat desc


select  count(sk.kitapID) as KitapAdeti , k.kullaniciAdi , k.kullaniciSoyadi from
Siparisler s inner join Kullanicilar k on s.kullaniciID=k.kullaniciID 
inner join siparis_kitap sk on s.siparisID=sk.siparisID
group by k.kullaniciAdi,k.kullaniciSoyadi,sk.siparisID having
count(sk.kitapID)>=5   order by KitapAdeti desc


select count(Year(siparisTarih)) as adet , YEAR(siparisTarih) as yil  from
Siparisler group by Year(siparisTarih) order by adet Desc


select top 1 count(*) as Adet , k.kitapAdi   from
Kitaplar k inner join siparis_kitap sk on k.kitapID=sk.kitapID
group by k.kitapAdi order by Adet Desc


select TOP 1 count(*) as Adet , k.kullaniciAdi,k.kullaniciSoyadi,s.siparisFiyat  from 
siparis_kitap sk inner join Siparisler s on sk.siparisID=s.siparisID 
inner join Kullanicilar k on s.kullaniciID=k.kullaniciID
group by k.kullaniciAdi,k.kullaniciSoyadi,sk.siparisID,s.siparisFiyat order by Adet Desc

select  count(*) as 'Kitap Sayisi',avg(kitapFiyat) as 'Ortalama Fiyat'  from Kitaplar


select count(*) as Adet , k.kitapAdi , y.yorumIcerik  from 
Yorumlar y inner join Kitaplar k on y.kitapID=k.kitapID
group by k.kitapAdi,y.yorumIcerik having count(*)<2 order by Adet 

select Top 1 count(YEAR(yorumTarih)) as Adet , YEAR(yorumTarih) as 'Yýllar'   from 
Yorumlar group by YEAR(yorumTarih) order by Adet Desc 

create view KullaniciSiparisOzeti as
select 
    k.kullaniciAdi,
    k.kullaniciSoyadi,
    count(s.siparisID) as toplamSiparisSayisi,
    sum(s.siparisFiyat) as toplamHarcama
from Kullanicilar k
inner join Siparisler s on k.kullaniciID = s.kullaniciID
group by k.kullaniciAdi, k.kullaniciSoyadi;


select * from KullaniciSiparisOzeti;


create procedure KitapYorumlari
    @kitapID int
as
begin
    select 
        y.yorumIcerik,
        y.yorumTarih,
        k.kullaniciAdi,
        k.kullaniciSoyadi
    from Yorumlar y
    inner join Kullanicilar k on y.kullaniciID = k.kullaniciID
    where y.kitapID = @kitapID
    order by y.yorumTarih desc
end;

exec KitapYorumlari @kitapID = 1;
