# Maintainer: Bernhard Landauer <oberon@manjaro.org>

pkgname=i3-scrot
pkgver=1.1
pkgrel=1
pkgdesc="simple screenshot script using scrot"
arch=('any')
url="https://forum.manjaro.org/index.php?topic=31977.msg261964#msg261964"
license=('GPL')
depends=('libnotify'
	'scrot'
	'xdg-user-dirs')
source=('i3-scrot')
md5sums=('d91bff3d11b1e6fc656e9f9388b2c95c')

package() {
  install -Dm755 "$srcdir/$pkgname" "$pkgdir/usr/bin/$pkgname"
}
