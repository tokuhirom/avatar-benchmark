package AB;
use strict;
use warnings;
use autodie;
use Imager;
use GD;
use Image::Imlib2;
use Graphics::Magick;

sub render_imager {
    my $img = Imager->new();
    my $base = $img->read(file => 'img/base.gif') or die;
    for my $i (reverse 1..7) {
        my $part = Imager->new();
        $part->read(file => "img/s$i.gif") or die;
        $base->rubthrough(src => $part, tx => 0, ty => 0) or die;
    }
    $base->write(file => 'out/imager.jpg', jpegquality => 90) or die;
}

sub render_gd {
    my $base = GD::Image->new('img/base.gif');

    for my $i (reverse 1..7) {
        my $part = GD::Image->new("img/s$i.gif");
        $base->copy($part, 0,0, 0,0, $base->width, $base->height);
    }

    # save
    my $jpeg = $base->jpeg(90);
    open my $fh, '>', 'out/gd.jpg';
    print {$fh} $jpeg;
    close $fh;
}

sub render_imlib2 {
    my $base = Image::Imlib2->load("img/base.gif");

    for my $i (reverse 1..7) {
        my $part = Image::Imlib2->load("img/s$i.gif");
        $base->blend($part, 0, 0,0,$base->width, $base->height, 0,0,$base->width, $base->height);
    }

    $base->set_quality(90);
    $base->image_set_format('jpeg');
    $base->save('out/imlib2.jpg');
}

sub render_gm {
    my $base = new Graphics::Magick;
    $base->Read("img/base.gif");

    for my $i (reverse 1..7) {
        my $part = Graphics::Magick->new();
        $part->Read("img/s$i.gif");
        $base->Composite(image => $part, compose => 'over', x => 0, y => 0);
    }

#   $base->set_quality(90);
#   $base->image_set_format('jpeg');
    $base->Set(quality => 90);
    $base->Write('out/gm.jpg');
}

1;
