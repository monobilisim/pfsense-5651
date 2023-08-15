[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

<div align="center"> 
<a href="https://mono.net.tr/">
  <img src="https://monobilisim.com.tr/images/mono-bilisim.svg" width="340"/>
</a>

<h2 align="center">pfsense-5651</h2>
<b>pfsense-5651</b>, pfsense içindeki belirli günlük kayıtlarını imzalamaya yarayan bir araçtır
</div>

---

## İçindekiler 

- [İçindekiler](#içindekiler)
- [Kurulum](#kurulum)
- [Kullanım](#kullanım)
- [Lisans](#lisans)

---

## Kurulum

1. `git clone https://github.com/monobilisim/pfsense-5651 logsign-tool` komutu ile repo klonlanır.
2. `cd logsign-tool` komutu ile proje klasörüne geçilir
3. `vim setup.conf` komutu ile gerekli bilgiler doldurulur.
4. `sh setup.sh` ile proje kurulur.
5. pfsense açılır. System -> Packages -> Available Packages (/pkg_mgr.php) sayfasından “Cron” paketi kurulur.
6. Services -> Cron (/packages/cron/cron.php) sayfası açılıp aşağıdaki yönergelere göre yeni bir cronjob eklenir;
  - Dakika: 59
  - Saat: 23
  - Ayın Günleri: *
  - Yılın Ayları: *
  - Haftanın Günleri: *
  - Kullanıcı: root
  - Komut: sh /sbin/logsigner.sh


---

[contributors-shield]: https://img.shields.io/github/contributors/monobilisim/pfsense-5651.svg?style=for-the-badge
[contributors-url]: https://github.com/monobilisim/pfsense-5651/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/monobilisim/pfsense-5651.svg?style=for-the-badge
[forks-url]: https://github.com/monobilisim/pfsense-5651/network/members
[stars-shield]: https://img.shields.io/github/stars/monobilisim/pfsense-5651.svg?style=for-the-badge
[stars-url]: https://github.com/monobilisim/pfsense-5651/stargazers
[issues-shield]: https://img.shields.io/github/issues/monobilisim/pfsense-5651.svg?style=for-the-badge
[issues-url]: https://github.com/monobilisim/pfsense-5651/issues
