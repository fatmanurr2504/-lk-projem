USE [KTS]
GO
/****** Object:  Table [dbo].[Kullanicilar]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kullanicilar](
	[kullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[kullaniciAdi] [nvarchar](50) NOT NULL,
	[kullaniciSoyadi] [nvarchar](50) NOT NULL,
	[kullaniciEposta] [nvarchar](70) NOT NULL,
	[kullaniciSifre] [nvarchar](12) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[kullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Siparisler]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Siparisler](
	[siparisID] [int] IDENTITY(1,1) NOT NULL,
	[siparisFiyat] [decimal](10, 2) NOT NULL,
	[kullaniciID] [int] NOT NULL,
	[siparisTarih] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[siparisID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[KullaniciSiparisOzeti]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[KullaniciSiparisOzeti] as
select 
    k.kullaniciAdi,
    k.kullaniciSoyadi,
    count(s.siparisID) as toplamSiparisSayisi,
    sum(s.siparisFiyat) as toplamHarcama
from Kullanicilar k
inner join Siparisler s on k.kullaniciID = s.kullaniciID
group by k.kullaniciAdi, k.kullaniciSoyadi;
GO
/****** Object:  Table [dbo].[Kitaplar]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kitaplar](
	[kitapID] [int] IDENTITY(1,1) NOT NULL,
	[kitapAdi] [nvarchar](50) NOT NULL,
	[kitapYazari] [nvarchar](50) NOT NULL,
	[kitapTuru] [nvarchar](50) NOT NULL,
	[kitapSayfaSayisi] [nvarchar](10) NOT NULL,
	[kitapBasimSayisi] [nvarchar](10) NOT NULL,
	[kitapFiyat] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[kitapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[siparis_kitap]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[siparis_kitap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[siparisID] [int] NULL,
	[kitapID] [int] NULL,
 CONSTRAINT [PK_siparis_kitap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Yorumlar]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Yorumlar](
	[yorumID] [int] IDENTITY(1,1) NOT NULL,
	[yorumIcerik] [nchar](500) NULL,
	[kullaniciID] [int] NULL,
	[kitapID] [int] NULL,
	[yorumTarih] [date] NULL,
 CONSTRAINT [PK_Yorumlar] PRIMARY KEY CLUSTERED 
(
	[yorumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[siparis_kitap]  WITH CHECK ADD  CONSTRAINT [fk_siparis_kitap] FOREIGN KEY([siparisID])
REFERENCES [dbo].[Siparisler] ([siparisID])
GO
ALTER TABLE [dbo].[siparis_kitap] CHECK CONSTRAINT [fk_siparis_kitap]
GO
ALTER TABLE [dbo].[siparis_kitap]  WITH CHECK ADD  CONSTRAINT [fk_siparis_sipariskitap] FOREIGN KEY([kitapID])
REFERENCES [dbo].[Kitaplar] ([kitapID])
GO
ALTER TABLE [dbo].[siparis_kitap] CHECK CONSTRAINT [fk_siparis_sipariskitap]
GO
ALTER TABLE [dbo].[Siparisler]  WITH CHECK ADD FOREIGN KEY([kullaniciID])
REFERENCES [dbo].[Kullanicilar] ([kullaniciID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Yorumlar]  WITH CHECK ADD  CONSTRAINT [fk_yorum_kitap] FOREIGN KEY([kitapID])
REFERENCES [dbo].[Kitaplar] ([kitapID])
GO
ALTER TABLE [dbo].[Yorumlar] CHECK CONSTRAINT [fk_yorum_kitap]
GO
ALTER TABLE [dbo].[Yorumlar]  WITH CHECK ADD  CONSTRAINT [fk_yorum_kullanici] FOREIGN KEY([kullaniciID])
REFERENCES [dbo].[Kullanicilar] ([kullaniciID])
GO
ALTER TABLE [dbo].[Yorumlar] CHECK CONSTRAINT [fk_yorum_kullanici]
GO
/****** Object:  StoredProcedure [dbo].[KitapYorumlari]    Script Date: 12/05/2025 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[KitapYorumlari]
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
GO
