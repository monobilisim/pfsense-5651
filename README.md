<p align="center"><br>
<a href="https://github.com/monobilisim/pfsense-5651/graphs/contributors"><img alt="contributors" src="https://img.shields.io/github/contributors/monobilisim/pfsense-5651.svg?style=for-the-badge"</img></a>
<a href="https://github.com/monobilisim/pfsense-5651/network/members"><img alt="forks" src="https://img.shields.io/github/forks/monobilisim/pfsense-5651.svg?style=for-the-badge"</img></a>
<a href="https://github.com/monobilisim/pfsense-5651/stargazers"><img alt="starts" src="https://img.shields.io/github/stars/monobilisim/pfsense-5651.svg?style=for-the-badge"</img></a>
<a href="https://github.com/monobilisim/pfsense-5651/issues"><img alt="issues" src="https://img.shields.io/github/issues/monobilisim/pfsense-5651.svg?style=for-the-badge"</img></a>
<a href="https://github.com/monobilisim/pfsense-5651/blob/master/LICENSE"><img alt="licenses" src="https://img.shields.io/github/license/monobilisim/pfsense-5651.svg?style=for-the-badge"</img></a><br><hr>
</p>

<div align="center">
<a href="https://mono.net.tr/">
  <img src="https://monobilisim.com.tr/images/mono-bilisim.svg" width="340"/>
</a>

<h2 align="center">pfsense-5651</h2>
<b>pfsense-5651</b>, pfsense içindeki belirli günlük kayıtlarını imzalamaya yarayan bir araçtır
</div>

---

## Kurulum

1. `fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/logsigner-setup.sh` komutu ile script dosyası çekilir.
2. `sh logsigner-setup.sh` komutu çalıştırılarak ilk etapta setup.conf dosyası çekilir.
3. Herhangi bir editör aracılığı ile `setup.conf` dosyası düzenlenir.
4. `setup.conf` dosyası düzenlendikten sonra `sh logsigner-setup.sh` komutu yeniden çalıştırılır ve kurulum tamamlanır.
