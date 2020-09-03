
#!/bin/bash

echo "----------------------------------------"
echo "-----WordPress installation script------"
echo "----------------------------------------"
echo "-----Version2.0-----"
apt update && apt full-upgrade -y
echo -e "\033[32mUpgrade done\033[0m"
sleep 2
apt install net-tools -y
apt install unzip -y
echo -e "\033[32mTools installation done\033[0m"
sleep 2
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
echo -e "\033[32msshd_config done\033[0m"
sleep 2
service ssh restart

apt install apache2 mysql-server-5.7 phpmyadmin php7.2 php7.2-cli php7.2-dev php7.2-gmp php7.2-json php7.2-odbc php7.2-pspell php7.2-soap php7.2-xml php7.2-bcmath php7.2-common php7.2-enchant php7.2-imap php7.2-ldap php7.2-opcache php7.2-readline php7.2-sqlite3 php7.2-xmlrpc php7.2-bz2 php7.2-curl php7.2-fpm php7.2-interbase php7.2-mbstring php7.2-pgsql php7.2-recode php7.2-sybase php7.2-xsl php7.2-cgi php7.2-dba php7.2-gd php7.2-intl php7.2-mysql php7.2-phpdbg php7.2-snmp php7.2-tidy php7.2-zip libapache2-mod-php7.2 php-intl -y
echo -e "\033[32mLAMP download done\033[0m"
sleep 2
systemctl reload apache2

systemctl restart apache2

mysql_secure_installation
echo -e "\033[32mmysql secure installation done\033[0m"
sleep 2

printf "CREATE DATABASE wordpress CHARACTER SET UTF8 COLLATE utf8_bin;\nCREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'Password1';\nGRANT ALL PRIVILEGES ON * . * TO 'wordpressuser'@'localhost';\nFLUSH PRIVILEGES;\nexit\n" | mysql
echo -e "\033[32mDatabase operations done\033[0m"
sleep 2

cd   /var/www/html/

wget https://tr.wordpress.org/latest-tr_TR.zip
echo -e "\033[32mWordPress download done\033[0m"
sleep 2
unzip latest-tr_TR.zip

cd /var/www/html/wordpress

rm -r wp-config-sample.php

cd /var/www/html/wordpress

touch wp-config.php

echo "<?php
/**
 * WordPress için taban ayar dosyası.
 *
 * Bu dosya şu ayarları içerir: MySQL ayarları, tablo öneki,
 * gizli anahtaralr ve ABSPATH. Daha fazla bilgi için
 * {@link https://codex.wordpress.org/Editing_wp-config.php wp-config.php düzenleme}
 * yardım sayfasına göz atabilirsiniz. MySQL ayarlarınızı servis sağlayıcınızdan edinebilirsiniz.
 *
 * Bu dosya kurulum sırasında wp-config.php dosyasının oluşturulabilmesi için
 * kullanılır. İsterseniz bu dosyayı kopyalayıp, ismini "wp-config.php" olarak değiştirip,
 * değerleri girerek de kullanabilirsiniz.
 *
 * @package WordPress
 */

// ** MySQL ayarları - Bu bilgileri sunucunuzdan alabilirsiniz ** //
/** WordPress için kullanılacak veritabanının adı */
define( 'DB_NAME', 'wordpress' );

/** MySQL veritabanı kullanıcısı */
define( 'DB_USER', 'wordpressuser' );

/** MySQL veritabanı parolası */
define( 'DB_PASSWORD', 'Password1' );

/** MySQL sunucusu */
define( 'DB_HOST', 'localhost' );

/** Yaratılacak tablolar için veritabanı karakter seti. */
define( 'DB_CHARSET', 'utf8mb4' );

/** Veritabanı karşılaştırma tipi. Herhangi bir şüpheniz varsa bu değeri değiştirmeyin. */
define('DB_COLLATE', '');

/**#@+
 * Eşsiz doğrulama anahtarları.
 *
 * Her anahtar farklı bir karakter kümesi olmalı!
 * {@link http://api.wordpress.org/secret-key/1.1/salt WordPress.org secret-key service} servisini kullanarak yaratabilirsiniz.
 * Çerezleri geçersiz kılmak için istediğiniz zaman bu değerleri değiştirebilirsiniz. Bu tüm kullanıcıların tekrar giriş yapmasını gerektirecektir.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '[Kj@#<;aV^lv0r4C4:h\$G}>L++&11mKY4-L>=tU\$yU]w(6!n2n}rzE-4vYaJ[^6V' );
define( 'SECURE_AUTH_KEY',  '}(W*N(>lMwIt}hVc_ix~sEx&|T DxH)tvT=./B }Eyr-kl\`*A]yu=cvyBfPcQ0o}' );
define( 'LOGGED_IN_KEY',    'jEPHjr;QAqJl33tc%cUEDzIu!OxC){Jfz[$mx5LfS.e>Wzksdru-?LN=Pq>rT(uN' );
define( 'NONCE_KEY',        '+.w9MSIyAru8K^1IgWmxpM]dHd+\`4*Q;[#[7&]Ig:dEz=.yPVvXBY;,$^cw1.33$' );
define( 'AUTH_SALT',        'ceb)e{(hLmEId; Mdp<I{*idPu2tbs\`MKpd{kvK>1qmiZrFJp^u~zZNt&{VTH>js' );
define( 'SECURE_AUTH_SALT', '>(Dx#,D}BF}#|puN]5-%/H%s[n]1hlfQ)?~bbIeF(u>-|v&;A* ]nu)#KPm[h@:V' );
define( 'LOGGED_IN_SALT',   'gn/abA:hPds5!hpMjT)mmlk6Y D/NoCfO.alA3lKo\$@:8Y1P Pa2R%\`NHxc-[ns@' );
define( 'NONCE_SALT',       '>HU_DV5gbZdH,Zys@5.V:S@?XNcWjsEiq(_uJbB,Gk<U{WZ\$\$49edj4^+!\$Y yn;' );
/**#@-*/

/**
 * WordPress veritabanı tablo ön eki.
 *
 * Tüm kurulumlara ayrı bir önek vererek bir veritabanına birden fazla kurulum yapabilirsiniz.
 * Sadece rakamlar, harfler ve alt çizgi lütfen.
 */
\$table_prefix = 'wp_';

/**
 * Geliştiriciler için: WordPress hata ayıklama modu.
 *
 * Bu değeri true yaparak geliştirme sırasında hataların ekrana basılmasını sağlayabilirsiniz.
 * Tema ve eklenti geliştiricilerinin geliştirme aşamasında WP_DEBUG
 * kullanmalarını önemle tavsiye ederiz.
 */
define('WP_DEBUG', false);

/* Hepsi bu kadar. Mutlu bloglamalar! */

/** WordPress dizini için mutlak yol. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** WordPress değişkenlerini ve yollarını kurar. */
require_once(ABSPATH . 'wp-settings.php');" >> wp-config.php


echo -e "\033[36m"
echo "-------------------------------"
echo "------Installation Done--------"
echo "------Powered by Ufkan, thanks for support to 'ofbahar'---------"
echo "------Your ip address;" $(ifconfig | grep inet | tail -n4 | head -n1 | awk '{print $2}')
echo "------Open your browser and type this-----"
echo "------http://ipaddress/wordpress----------"
   
