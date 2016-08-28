use Net::Ping;
use v5.10;


$host = defined $ENV{TETRIS_HOST} ? $ENV{TETRIS_HOST} : "8.8.8.8";
$timeout = $ENV{TETRIS_TIMEOUT} ? $ENV{TETRIS_TIMEOUT} : 1;
$os = "$^O";

updateState();

$ping = Net::Ping->new("icmp");

$isInternetPresent = undef;
$currentStateCounter = 0;


while(1) {

	say "pinging " . $host;
	$newState = $ping->ping($host);
	if ($newState != $isInternetPresent) {
			$isInternetPresent = $newState;
			playJingleForState($newState) if $currentStateCounter > 5;
		} else {
			$currentStateCounter++;
		}



		sleep 1;
}

sub updateState {
}

sub playJingleForState {
	@goodJingles = <audio/good/*>;
	@badJingles = <audio/bad/*>;

	if (scalar @goodJingles <= 0) {
		say "Please check good jingles";
		exit 1;
	}

	if (scalar @badJingles <= 0) {
		say "Please check bad jingles";
		exit 2;
	}

	$forGoodState = shift;

	$jingleToPlay = undef;
	if ($forGoodState) {
		$jingleToPlay = @goodJingles[rand @goodJingles];
	} else {
		$jingleToPlay = @badJingles[rand @badJingles];
	}

	system("afplay", $jingleToPlay) if $os eq "darwin";
	system("play", $jingleToPlay) unless $os eq "darwin";


}