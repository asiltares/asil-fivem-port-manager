[Türkçe](#turkce) | [English](#english)

<a id="turkce"></a>

# asil-fivem-port-manager

FiveM / FXServer sunucuları için Windows Defender Güvenlik Duvarı port yönetim aracıdır. FiveM sunucu portu (`30120` TCP/UDP) ve txAdmin paneli portu (`40120` TCP) için gelen bağlantı kurallarını kontrol eder, eksikse oluşturur, varsa korur, siler veya yeniden oluşturur.

> **Önemli:** Bu araç yalnızca Windows Güvenlik Duvarı kurallarını yönetir. Modem/router üzerinde port yönlendirme (port forwarding) yapmaz ve üçüncü taraf güvenlik duvarlarını etkilemez.

## Nasıl çalışır?

- [`start.bat`](start.bat) açıldığında önce dil seçimi sunar: `[1] Turkce` veya `[2] English`.
- Yönetici izni yoksa kendini yönetici olarak yeniden başlatır. Seçilen dil yeni pencereye aktarılır, tekrar sorulmaz.
- Aşağıdaki kuralları sırayla, tam adlarıyla kontrol eder:

| Kural adı | Protokol | Port |
| --- | --- | --- |
| `FiveM Server 30120 TCP` | TCP | 30120 |
| `FiveM Server 30120 UDP` | UDP | 30120 |
| `txAdmin 40120 TCP` | TCP | 40120 |

- Kural **varsa**: koru, sil veya sil ve yeniden oluştur seçenekleri sunulur.
- Kural **yoksa**: oluşturulup oluşturulmayacağı sorulur.
- Oluşturulan kurallar gelen bağlantılar için (`Inbound`), tüm profillerde (`Any`) ve `Allow` olarak eklenir.
- İşlem bitince durumu tekrar kontrol edebilir veya çıkabilirsiniz.
- Araç internete bağlanmaz, arka planda çalışmaz ve yalnızca yukarıdaki adlara sahip kurallara dokunur.

## Gereksinimler

- Windows 10 / 11 veya Windows Server 2016 ve üzeri.
- Windows PowerShell (sistemde varsayılan olarak bulunur). Ek kurulum gerekmez.
- Güvenlik duvarı kurallarını değiştirmek için yönetici izni. Araç gerektiğinde Windows izin penceresini açar.

## Kullanım

`start.bat` dosyasına çift tıklayın, dili seçin ve Windows yönetici izni isterse onaylayın. Ardından her kural için ekrandaki seçenekleri takip edin.

Dil seçimini atlamak için dili parametre olarak verebilirsiniz:

```bat
start.bat TR
start.bat EN
```

## Seçenekler

| Durum | Seçenek | İşlev |
| --- | --- | --- |
| Kural var | `1` | Kuralı korur, dokunmaz. |
| Kural var | `2` | Kuralı siler. |
| Kural var | `3` | Kuralı silip aynı ayarlarla yeniden oluşturur. |
| Kural yok | `E` / `Y` | Kuralı oluşturur. |
| Kural yok | `H` / `N` | Kural oluşturmadan geçer. |
| Bitiş | `E` / `R` | Kuralları tekrar kontrol eder. |
| Bitiş | `H` / `Q` | Çıkar. |

## Kaldırma

Aracı tekrar çalıştırıp her kural için `2` (Sil) seçeneğini kullanın. Yalnızca bu aracın kural adlarıyla eşleşen kurallar silinir; diğer güvenlik duvarı kurallarına dokunulmaz.

## Kapsam ve sınırlar

Araç kuralları yalnızca tam ad eşleşmesiyle bulur. Aynı portlar için daha önce farklı bir adla oluşturulmuş kurallar algılanmaz ve "yok" olarak görünür. Oluşturulan kurallar kaynak IP kısıtlaması içermez; txAdmin `40120` portunu mümkünse yalnızca kendi IP adresinize açmanız önerilir. Sunucu portunuz farklıysa `start.bat` içindeki `:MAIN` bölümündeki port değerlerini düzenleyin.

---

<a id="english"></a>

# asil-fivem-port-manager

A Windows Defender Firewall port manager for FiveM / FXServer servers. It checks the inbound rules for the FiveM server port (`30120` TCP/UDP) and the txAdmin panel port (`40120` TCP), creates them when missing, and lets you keep, delete, or recreate them when they already exist.

> **Important:** This tool only manages Windows Firewall rules. It does not configure port forwarding on your modem/router and does not affect third-party firewalls.

## How does it work?

- When [`start.bat`](start.bat) opens, it first offers a language choice: `[1] Turkce` or `[2] English`.
- If it is not running as administrator, it restarts itself with elevated rights. The selected language is passed to the new window and is not asked again.
- It checks the following rules in order, by exact name:

| Rule name | Protocol | Port |
| --- | --- | --- |
| `FiveM Server 30120 TCP` | TCP | 30120 |
| `FiveM Server 30120 UDP` | UDP | 30120 |
| `txAdmin 40120 TCP` | TCP | 40120 |

- If a rule **exists**: you can keep it, delete it, or delete and recreate it.
- If a rule **is missing**: you are asked whether to create it.
- Created rules are added as `Inbound`, for all profiles (`Any`), with the `Allow` action.
- When finished, you can recheck the rules or quit.
- The tool does not connect to the internet, does not run in the background, and only touches rules with the names above.

## Requirements

- Windows 10 / 11 or Windows Server 2016 and newer.
- Windows PowerShell (included by default). No additional installation is required.
- Administrator permission to modify firewall rules. The tool opens the Windows permission prompt when needed.

## Usage

Double-click `start.bat`, choose a language, and approve the Windows administrator prompt if it appears. Then follow the on-screen options for each rule.

To skip the language prompt, pass the language as a parameter:

```bat
start.bat TR
start.bat EN
```

## Options

| State | Option | Purpose |
| --- | --- | --- |
| Rule exists | `1` | Keep the rule untouched. |
| Rule exists | `2` | Delete the rule. |
| Rule exists | `3` | Delete and recreate the rule with the same settings. |
| Rule missing | `Y` / `E` | Create the rule. |
| Rule missing | `N` / `H` | Skip without creating the rule. |
| End | `R` / `E` | Recheck the rules. |
| End | `Q` / `H` | Quit. |

## Removal

Run the tool again and choose `2` (Delete) for each rule. Only rules matching this tool's rule names are removed; other firewall rules are left untouched.

## Scope and limitations

The tool finds rules by exact name only. Rules created earlier for the same ports under a different name are not detected and are shown as missing. Created rules have no source IP restriction; if possible, open txAdmin port `40120` only to your own IP address. If your server uses a different port, edit the port values in the `:MAIN` section of `start.bat`.
