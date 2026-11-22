part of 'helpers.dart';

const String kAppName = "GMAX IPTV";
const String kAppNamePro = 'GMAX PRO';
const String kAppId = "com.gmax.iptv";
const String kAppVersion = "1.0.0";

//TODO: STATUS ADS ( true / false )
const bool kShowAds = false;

///SOCIAL MEDIA ACCOUNTS
const String kEmailSupport = "moad.devloper@gmail.com";
const String kReviewApp = "https://codecanyon.net/user/azul_mouad/portfolio";
const String kTwitter = "https://codecanyon.net/user/azul_mouad/portfolio";
const String kFacebook = "https://codecanyon.net/user/azul_mouad/portfolio";
const String kInstagram = "https://codecanyon.net/user/azul_mouad/portfolio";

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///

const bool kIsDebugTest = false;

const String kVideoBunny =
    "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4";

List<OfferSettings> offersSetting = [
  OfferSettings(
    title: "Ads free",
    body:
        "Commercials does not interrupt premium user. Enjoy your content without any interuption!",
    color: Colors.green.light,
    icon: FluentIcons.mobile_selected,
  ),
  OfferSettings(
    title: "Appearance",
    body: "Customize the app the way you want, Change theme and apperance!",
    color: Colors.red.light,
    icon: FluentIcons.lightbulb_solid,
  ),
  OfferSettings(
    title: "Advanced player",
    body: "Picture in Picture, subtitle, Support all video and live formats",
    color: Colors.orange,
    icon: FluentIcons.video,
  ),
  OfferSettings(
    title: "Intuitive design",
    body: "Search, filter , save, hide your channels with ease",
    color: Colors.purple.light,
    icon: FluentIcons.design,
  ),
  OfferSettings(
    title: "Stay in sync",
    body:
        "Keep your playlist, favorites, and watched history in sync with other devices.",
    color: Colors.blue.normal,
    icon: FluentIcons.school_data_sync_logo,
  ),
  OfferSettings(
    title: "HD Quality Audio",
    body: "Hear minute details with additional support for HD Audio",
    color: Colors.blue.darkest,
    icon: FluentIcons.communications,
  ),
  OfferSettings(
    title: "Exclusivity",
    body: "Get exclusive access to new features and much more 🎁",
    color: Colors.teal,
    icon: FluentIcons.personalize,
  ),
];

///
///
///
///
///
///
/// DO NOT CHANGE CODES ABOVE
///
///
///
///
///
///
///
///
///
const String kUpdateLive =
    "Please be patient while the Live data is being updated. It may take some time, so kindly refrain from closing the application.";
const String kUpdateSeries =
    "Please be patient while the Tv SHows data is being updated. It may take some time, so kindly refrain from closing the application.";
const String kUpdateMovies =
    "Please be patient while the movie data is being updated. It may take some time, so kindly refrain from closing the application.";
const List<String> kExampleChannels = [
  "https://cdn.futura-sciences.com/buildsv6/images/largeoriginal/0/3/0/030dc01da7_50145928_netflix-logo.jpg",
  "https://avpn.asia/wp-content/uploads/2016/03/National-Geographic-logo.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Star_Wars_Logo.svg/640px-Star_Wars_Logo.svg.png",
  "https://yt3.googleusercontent.com/fGvQjp1vAT1R4bAKTFLaSbdsfdYFDwAzVjeRVQeikH22bvHWsGULZdwIkpZXktcXZc5gFJuA3w=s900-c-k-c0x00ffffff-no-rj"
];
const String kIconSplash = "assets/images/icon.png";
const String kIconSplashSvg = "assets/images/icon.svg";
const String kImageIntro = "assets/images/intro h.jpeg";

const String urlImage =
    "https://m.media-amazon.com/images/M/MV5BMTg0NjEwNjUxM15BMl5BanBnXkFtZTcwMzk0MjQ5Mg@@._V1_.jpg";
const String urlImageCharacter =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Benedict_Cumberbatch_filming_Sherlock_cropped.jpg/188px-Benedict_Cumberbatch_filming_Sherlock_cropped.jpg";
const String m3uVideo = "http://getvx7.xyz:8080/33djk8vwyry/33djh4uyhfk/49950";

const String kPrivacy =
    "https://www.blogger.com/blog/post/edit/preview/5788409183816760891/1952955104364322311";
const String termOfUs = "https://www.whmcssmarters.com/terms-of-service/";
const String kContact = "https://mouadzizi.me";

const String videoM3u_1 =
    "http://new-pro.tv:8080/movie/07506371039/muhamad2023/417945.mkv";

const String videoM3u_2 =
    "https://stmv1.transmissaodigital.com/cidadeverdenovo/cidadeverdenovo/playlist.m3u8";
const String videoBunny =
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";

enum TypeCategory {
  all,
  live,
  movies,
  series,
}
