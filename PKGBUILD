# Maintainer: Whyte Richardson <your@email.tld>

pkgname=minerva-radio
pkgver=1.0.0
pkgrel=1
pkgdesc="Terminal VGM radio station with spectrum visualiser and request system"
arch=('any')
url="https://github.com/TheWhyteWolf/MiNERVA-Radio"
license=('MIT')
install=minerva-radio.install
depends=(
    'bash'
    'tmux'
    'mpv'
    'python'
    'libpulse'
    'ffmpeg'
    'vgmplay'
    'unrar'
    'curl'
    'bc'
    'sidplayfp'
    'vspcplay-git'
)
optdepends=(
    'cli-visualizer'
source=("$pkgname-$pkgver.tar.gz::https://github.com/TheWhyteWolf/MiNERVA-Radio/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$srcdir/MiNERVA-Radio-$pkgver"

    install -dm755 "$pkgdir/usr/lib/$pkgname"
    install -dm755 "$pkgdir/usr/bin"
    install -dm755 "$pkgdir/usr/share/doc/$pkgname"
    install -dm755 "$pkgdir/usr/share/licenses/$pkgname"

    local scripts=(
        minerva
        minerva-radio
        minerva-request
        minerva-index
        minerva-index-spc
        minerva-index-basic
        minerva-xtract
        minerva-xtract-rsn
        minerva-rename-rsn
        minerva-rename-spc
        minerva-setup
    )

    for script in "${scripts[@]}"; do
        install -m755 "$script" "$pkgdir/usr/lib/$pkgname/$script"
        ln -s "/usr/lib/$pkgname/$script" "$pkgdir/usr/bin/$script"
    done

    install -m644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    install -m644 LICENSE   "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
