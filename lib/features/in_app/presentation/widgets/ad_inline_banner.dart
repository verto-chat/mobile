import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../common/common.dart';
import '../managers/subscription_bloc.dart';

class SmartAdInlineBanner extends StatelessWidget {
  const SmartAdInlineBanner({super.key, required this.adUnitId});

  final String adUnitId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return state.subscription.showAd ? AdInlineBanner(adUnitId: adUnitId) : const SizedBox.shrink();
      },
    );
  }
}

class AdInlineBanner extends StatefulWidget {
  const AdInlineBanner({super.key, required this.adUnitId});

  final String adUnitId;

  @override
  State<AdInlineBanner> createState() => _AdInlineBannerState();
}

class _AdInlineBannerState extends State<AdInlineBanner> {
  BannerAd? _bannerAd;
  static const _insets = 16.0;
  bool _isLoaded = false;
  AdSize? _adSize;
  late final ILogger _logger;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  @override
  void initState() {
    _logger = context.read();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  void _loadAd() async {
    await _bannerAd?.dispose();
    setState(() {
      _bannerAd = null;
      _isLoaded = false;
    });

    AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(_adWidth.truncate());

    debugPrint('size: $size');

    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          _logger.log(LogLevel.info, 'Inline adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            _logger.log(LogLevel.error, 'Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _bannerAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null && _isLoaded && _adSize != null
        ? Align(
            child: SizedBox(
              width: _adWidth,
              height: _adSize!.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
        : const SizedBox.shrink();
  }
}
