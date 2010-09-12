use Benchmark qw/:all/;
use lib 'lib';
use AB;

timethese(
    1000 => {
        gm => sub {
            AB->render_gm();
        },
        gd => sub {
            AB->render_gd();
        },
        imager => sub {
            AB->render_imager();
        },
        imlib2 => sub {
            AB->render_imlib2();
        },
    }
);

