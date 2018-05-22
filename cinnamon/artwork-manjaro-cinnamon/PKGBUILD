# Maintainer: Bernhard Landauer <oberon@manjaro.org>

pkgbase=artwork-manjaro-cinnamon
pkgname=('artwork-cinnamon-minimal' 'cinnamon-wallpapers')
_grepo=gnome-backgrounds
_gver=3.28.0
pkgver=20180521
pkgrel=2
pkgdesc="Wallpapers for Manjaro Cinnamon"
arch=('any')
license=('GPL3')
makedepends=('git'
    'glib2'
    'meson')
default="adapta-maia.jpg" # default wallpaper to be packaged in artwork-minimal
greeter_default="cinnamon-adapta-maia.jpg" # default background
target="/usr/share/backgrounds/cinnamon"
_gurl="https://download.gnome.org/sources/$_grepo"
_murl="https://github.com/oberon2007/$pkgbase"
source=("$_gurl/${_gver:0:4}/$_grepo-$_gver.tar.xz"
    "git+$_murl.git")
sha256sums=('b25b963d9d1ce076b489ef1e85c6540166f2312c77132f4ec0ecc90f3da8f1e1'
            'SKIP')

pkgver() {
    date +%Y%m%d
}

build() {
    msg "build gnome-backgrounds"
    arch-meson $_grepo-$_gver build
    ninja -C build
}

check() {
    cd build
    meson test
}

package_artwork-cinnamon-minimal() {
    depends=('manjaro-icons')
    optdepends=('cinnamon-wallpapers: more wallpapers for Manjaro Cinnamon')
    provides=("$_grepo=$_gver")
    conflicts=("$_grepo")

    ext=$(echo $default | cut -d'.' -f2)
    ext2=$(echo $greeter_default | cut -d'.' -f2)

    DESTDIR="$pkgdir" ninja -C $srcdir/build install

    # fix default dir listing
    cd $pkgdir/usr/share/gnome-background-properties
    rm adwaita.xml
    mv gnome-backgrounds.xml gnome.xml

    cd $srcdir/$pkgbase
    install -Dm644 backgrounds/$default $pkgdir/$target/$default
    install -m644 backgrounds/$greeter_default $pkgdir/$target/$greeter_default
    ln -s $target/$default $pkgdir/usr/share/backgrounds/cinnamon_default.$ext
    ln -s $target/$greeter_default $pkgdir/usr/share/backgrounds/greeter_default.$ext2

    cp -r icons $pkgdir/usr/share/
    ln -s /usr/share/icons/manjaro/maia/48x48.png $pkgdir/usr/share/icons/manjaro-maia.png
}

package_cinnamon-wallpapers() {
    msg "build manjaro-cinnamon backgrounds"
    make -C "${pkgbase}/backgrounds" install DESTDIR="$pkgdir"
    rm $pkgdir/$target/{$default,$greeter_default}
}
