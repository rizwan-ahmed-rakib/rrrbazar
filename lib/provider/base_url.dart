import 'package:shared_preferences/shared_preferences.dart';

import '../app_flavor.dart';

/////////////////main api url////////////////////////////////////

final String backendUrl = "https://api.cobratopups.com";
final flavourClientOrigin  = AppConfig.instance.flavourClientOrigin;



/////////////////// client origin to request static ///////////////////

// final String ClientOrigin = "https://zsshopbd.com";
// final String ClientOrigin = "https://cobratopups.com";
// final String ClientOrigin = "https://bdgamebazar.com";
// final String ClientOrigin = "https://pipo-bazar.com";
// final String ClientOrigin = "https://evo-topup.com";
// final String ClientOrigin = "https://rangvotopup.com";

/////////////////// client origin to request dynamic// /////////////////

final String ClientOrigin = flavourClientOrigin;



