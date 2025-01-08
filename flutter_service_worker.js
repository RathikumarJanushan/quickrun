'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "b277bf5724d2d1ecfd768cdf4a6998ab",
".git/config": "6919344cf3902dbe88dacfc3d33b8aa3",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "2d7a2142ea166794c1f062640de702cb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "ddd6d56bb224987e2bf2b04876990b45",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "1f2a8c004482b9b24b51dd6ea7550426",
".git/logs/refs/heads/janu": "75dfd4aa059300dda0bf4c87e6ff74f5",
".git/logs/refs/remotes/origin/janu": "dd653ed5be4a939e6e9632394d312606",
".git/objects/03/116e5049e47bb6e94478d77949e04ee68b925d": "3d946dc5fc40050007753b1b894007fd",
".git/objects/03/ba2bbb063a443a1b98c38bb26317be72b561b2": "21af61b1cafd5729bfbc19b2297e1b75",
".git/objects/07/79375a55c36f3104b2cd88756f2f897ab42d81": "6d2082d5a9684768c5b9b0387a158ab2",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/09/cb4e93264ec54448e9bb253c5cc33893035692": "8482b6e7480061dc1743ba178063d089",
".git/objects/09/d4f3c361cf3c91d59af2b12893d8898950fa2e": "a62b29917c35ea048af49f67f0016133",
".git/objects/0a/03411cb77f99f379fa7637686bfad390f0582c": "80af6009d5f928fbe6c9c4fb2e16cb06",
".git/objects/10/2a3d2ce59c4e46da801f91aab02645a975721d": "d4df8a1a663b6e47c0978a055588dba0",
".git/objects/11/00a3a52a10e56cce2cada6564a6491bea9eb16": "0bacf78399e43cecc9ba7b1ca9a61c80",
".git/objects/11/889763f0e09e1305e699181d354243e9e2f1f7": "0e34c9842c6c1dd31a8f7d09622afadf",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/1f/bf3fe407d4c5724bdc7e3495c08ac06357b627": "5510b86765d8a5d35fff174cc8e0123d",
".git/objects/20/41cb7e81b6916169570ed42efadfe5e8dfaf54": "ef3ac766f9511721be2af3b2d0d43ab8",
".git/objects/22/4694227bc188c2ac34df90f1805c075c89caad": "f3d9ad3ae6b1c8940efb4ca07e43bd16",
".git/objects/23/9d69dc23299efaf89c57c0879b9c18a56919ed": "dbb7f0b3fc967e97fc8a17984de7c584",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/26/05b29de641745def12cfccde6c8112b393e224": "f90d7d6b586a4b25776d85e594b4bce7",
".git/objects/27/5105421755ee375b9036cbcdc8850f79b7c5b0": "2b707700cf33f2a6b89be44a94553aeb",
".git/objects/29/ca1f6aaac1bd6e6698cbcd4f4bed9bb42102ea": "6721a26d3526ddd805f5e31b45cfa4c5",
".git/objects/2b/d94d240d42d8dca165e1aed0501797eb419c07": "3ce4694bbbf94f595ac1ba45af15426c",
".git/objects/2d/348df70ef0e7bf10e544fba2e1c2ea6d81f8b1": "0f58a78ae7d5711bf9078bd8a9e7ced0",
".git/objects/30/a9db6e5d0ee8c146eede717385539b413eea48": "4a8d811693a93f8961b6eec14abbd709",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/37/bd4e6120e6fa5157b0e9ecc72135933df2f108": "21539ad642613942f3fe8a057f147e02",
".git/objects/39/6977c9d90c12b160037349b97649d7a3992849": "5f3fb082c72c44e250ca91e4dc80882d",
".git/objects/3a/72d5234b2f4c94c0b420509d51340a482f341e": "9030be91f0970e20f33d698a4dcbfb4b",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/3e/2ffe5a594353274d77ff3ed051b94572954796": "349516495cc80f166cd99bb9be4b476b",
".git/objects/3e/53a7f10f79a94efa1be0264f2401e2a9982985": "0f367e43bbf5b60b4a264c3f92c53a0f",
".git/objects/40/0d5b186c9951e294699e64671b9dde52c6f6a0": "f6bd3c7f9b239e8898bace6f9a7446b9",
".git/objects/40/f09533e507631e66459cc08048ea8a52523d32": "f4c209276459e14100b5c78f02653f61",
".git/objects/43/83c9def79b89c86e6125ad89d70a425ba782e9": "0d6cfca2039ea3af0f8fe5092e4cbad1",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/45/0025b5deff335970d5ef8933f7a321d8e007fc": "9b8879e7de299c5fead3b6243e1a6d7f",
".git/objects/47/99344f60557605b5a355582e7ab2889d6c196e": "23beaf0abf21e55e571fa10656b89578",
".git/objects/4b/008101cbd6bc0545d86fee7a41d03f356366f9": "7ea3496936a435b2a0bd71eddd153d9b",
".git/objects/4f/54f6f7dd43dd11f102601be769c8448318cee5": "bfae2c93167facb51c4050ac9c4b73cc",
".git/objects/51/131353bc22cffef6e59793f1a45aa74a6740be": "a9167377312ad862f24767ee8bc55777",
".git/objects/54/49aedad6ab2732bd97ade781d1a346dce94c35": "6f2c8d2e725c5a73f888cce605952cb0",
".git/objects/56/a358560fbfd59dc48d569b7bf0ba2b8b7cc296": "e1e7bad153e22c81af56b3e5b5339353",
".git/objects/58/4e2117bd7ecaa556ce7eb13408f1a3dc92875d": "486749c2da981aec99f27b3e1794b906",
".git/objects/5b/e0de6dc628267961003b6531d72f907e853501": "7ae9e7b92db21747bb64de9e45ad25da",
".git/objects/65/65904e2b787077ee131cbb330ec38d69b3fafd": "918f41911c9a19d7cdc64583536da08d",
".git/objects/68/6f1c261f189b2cf524385d18f2d41e461affc1": "6c963fa53302ae5f74bbe558222be41c",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/6f/d1bbff6e0033bc47080c5f3aca9f47c078345c": "a74eccaf1b99787048680c517660fdba",
".git/objects/70/50eddbdd06c1ab7a0187fb9e54fb687ab2893e": "1b0fedefa86ced3849ae903e7a013952",
".git/objects/73/7760b5df73bf4e48e8d17146a574e8deabc80d": "13d16aef91d25b6dde089b816cc1d6a7",
".git/objects/73/fa580e6fbce3b02d0b65ef2164334b7f207002": "fcbdcd3471f62462a016ce58b16aa742",
".git/objects/75/8f0027f1ff7e0637f0ed8b35ce3b54806d8032": "3ca247265075d23619060ac3bb82c5d2",
".git/objects/78/073dfd525f9384f30566d783aac7cfd7c30e83": "cbfa4dd7535dd6c4e7103174b1531ccf",
".git/objects/78/d5a0b2578958af46bbff5d187beab5e421713d": "30a42e158804bc59aa3825d51a40d1d8",
".git/objects/78/e6a5121ea18bc491117788d4224f21cc88ade1": "b4d02896e1b167aeb2f18970edadf1fd",
".git/objects/79/1fec66ced8c6fc058eb2bbf190c0e411880caa": "f9096f6da7777505987f473ebde54006",
".git/objects/7e/68e43ffe427b8c1beb26965edbfeacf225692b": "88c6082b1bcd06f12efd93b47800f02a",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/8ef11a9f38006f9d287e86031edace0d94b940": "23d33085e714c30da94f73fb6996eeed",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8e/d8e768c8413a2cadfc74a3dfbf105ca2f1bdef": "b5572d366020671c87e9b9d62b3fc6a2",
".git/objects/90/466ee9a32de5715c1efd93835546a9b9224176": "d661adbb5d529325d5ab102828d74cf9",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/91/9379bc400ec84f21d9e6c709eb1b16944e9208": "3cebbc20136456ea61e13888ebe0a6e3",
".git/objects/96/90be5d88b58fb5a10e5bfd7477208420b2448b": "1037f359bbf460e58e6418463981de29",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/9c/0a237eebd38a5e05c1aaf48becc5439bf46da6": "e580c093a691a0948343706925a96352",
".git/objects/9c/30a59d508947a31c72db83caa9539ff415df51": "aab3aef03429f589c381b7f7c3e0cabd",
".git/objects/9f/88aa56b47acc9f44dbb46c4e512e4b60e97d51": "f3638686889d9c4275744b239d814295",
".git/objects/a1/5174a762f0db8f9f82e119baaa149c9daebc4a": "3a862eb960539a65cf3fc3be7ec33bf5",
".git/objects/a1/8c7060260a5a5723ba7eb5f1e720a818ff5ed4": "0dbc284a5bfcafa70edd4df7f4a6809b",
".git/objects/a4/2b9410fc295d09056573a49358cc9851b28602": "329166fac88929464eeb15da0759f5a6",
".git/objects/a4/c5a48850a89f6a6fc8624ea91f7541a6624fe2": "a5f009ae07b4437e40034cc9fd4bca09",
".git/objects/a4/dfa3741d029c95788f5a4b36eb36cfc8432144": "5d0cd4367e285703e229f92ce2087e95",
".git/objects/a5/b5a91dec5ec62baf10a9f218134c246fc5d15d": "bb8577b9d2f39af0031f5f7e0908b081",
".git/objects/a7/cf6a3b7d1fce83cc22f7502106a2e0d2a2b3ec": "ae955fccd1e67a75c0c9d446475d2656",
".git/objects/a9/05726081f7e2197d7a3b4d123e4e6d3240f119": "e2c92862c45715ff67689f2b63e290d0",
".git/objects/aa/205bc4b3c6812bd1e9e7b4fbd09d8248f8ea6b": "3efb69a41e5d90a04b4d1e49db40e8a3",
".git/objects/ab/ccb0a84394526ec4771ac925afb646202f09ec": "e38d4dc7df868d807d50c31ad4546fe2",
".git/objects/ad/e4954ff7dbc953243c02121e06b66870899af0": "335da4d2f6d37a86d4296a0e0c197c7f",
".git/objects/af/70ee174238ce7fe8f7266522d0a780443d2180": "e732eff3a2285cd6e9603b51e09b5308",
".git/objects/b1/269bc53e1b762c3d0fedaa0a8769a0da6d57ad": "04949904b21261e14b17ab8f556d65ca",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b3/2154da869ce93f968e19c977231711669b0c6c": "44eef81546031147dbee50679f8cebe2",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/e0987745e2f0a418f03b20d284e27dda5f30a1": "d45c49bdcc11c66bc523b5df27a6de56",
".git/objects/ba/339c2e80e993086e4d6162a6ae9715ee8df861": "9eb5f6cfa06e42734fa20ba1e85c475c",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/ba/678e9bb161fb97eddad7c09f21fdf365958cc7": "cd803df946eab4ed443be453f10628f4",
".git/objects/bc/be486e8a67da8db8ab87a702c152cf49bbd7cc": "4d997936da93dc95233dd9fba66eaa9f",
".git/objects/bc/e7fa0736b396a37c2fee3d304c068a1b8d2d63": "4a543af697246367e9729e084d3fd1a2",
".git/objects/be/45d946c07f8230e2b947232daa0e40ab2751c8": "1a5f0611778eaa49bb28818ac77d255c",
".git/objects/bf/c07d1a12db201a0d99d36484334e8bca8499f1": "dfbb22b3d5f2a87ea6d7c990a2862df2",
".git/objects/c1/f8bcd19d8e72be188f6c188212dd003b8ad36a": "b19a644dbc18678363157a84400b0129",
".git/objects/c3/2dbfd4f43c6307abb34bdc0d89075a4805cd6e": "9d7d83748f05d634efd75ca10ae23339",
".git/objects/c4/88b7927c418276f267bb86a1b758183e5f85f1": "26c3de6dd343e0040844cc62d99d89c5",
".git/objects/c5/f50a526f8db42c7f4d26272c4f48945b5fdd10": "960f934ab12d71b8c7b04eb874acb147",
".git/objects/c8/5c20cfcce978f06e9e65f80c1f37933c2c3365": "eb2ccfc3e671b4cbed114580b4f03016",
".git/objects/c9/331b711f95c5cc3796a14b811f5eba6accc694": "b537195044e86fb819182f92195c3226",
".git/objects/ca/0b9ecf126179568ef206a6e176732d7c87defd": "8d109fc6d7ff1090e6734d0980fcc80a",
".git/objects/ca/cc79262d40c450bf8c739a5586ef2aa482c107": "40c29ee2bab1b9111ee39d9a6c736f13",
".git/objects/cb/2aa7772270884b136c7451f30ca78d84c12575": "c2b703fa98b01715e503a8ba482299a6",
".git/objects/cd/0d5d759fb2cdc028f5c1e7713a3802496b45c8": "396051be194469647449c8e84b3f322e",
".git/objects/cd/54861169744c236fed7991f9abb53abb440cc6": "8df7c73d4e2a25bf0ca852535fdd1c41",
".git/objects/cd/6953449f888aafa20b7c9b449ba31c977b30f9": "2241ec0f0e6be7396fb3ecad285d15ec",
".git/objects/cf/381de59a3f611290bf3e8c0b7a71bc9836adb3": "c90f791d38b5ce41c5bf1832495630a3",
".git/objects/d0/0b8c1eeae8991eceea3bc15c39360ab41083f3": "c58686b2a34a339e8f35bf9c117732c3",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d5/bb50b3c3bc534b51ba035a5e8495ba7af5025b": "81d30e6f235d2cd1960b1a0d917b3043",
".git/objects/d6/5beb46f69d458c1fde93c1e6f88529ca0f3ec0": "266ba8f7b3a3e0fd9a97acb4161f2a30",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/2b5122780df8e144cfbc488c66b2358527afa1": "627a04c48248c33176aeb3eb835e3250",
".git/objects/d9/cad5efdacdd4a7be6fa10a4a32ac55c31f8589": "0ebb5b61f6de2a5e9c7a448504491078",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/dd/767141e3a5c0825b41ce9faac5ac6d06d64acb": "b160339cd8b8071547b87eb9a3438a63",
".git/objects/de/420be8bbeaf51bc8714fa35009c01f0d8a948f": "bf4f0d0a6348bfd7cdfe726f31d8c504",
".git/objects/df/8e5dd0a37e2041026b7754bcac77387a0d2e64": "3829096bc27436ca82db78d78d6bc48e",
".git/objects/e1/09890c14d72aaf3621d6a1c7cc1b907ae9b0c6": "8df81f3800def833448aab222480b7fd",
".git/objects/e3/649909157414b93ab3b57a4b610b0ca8682532": "f8120619bb61cb869fd16f73565abd77",
".git/objects/e8/1122d5e1add9eb0a1e159a31c0d3eab32db3b0": "83e62e6dcbe3234b96b8a1e7cd444c6b",
".git/objects/eb/42c3d69684b0b92933bfe0c2d99a7187278da1": "c4147a992823e7052508ee5eb6f067d1",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/0c3114a75979559ecd28e1f5e85a0ec854f19c": "a84352ecee45e8a5c4c95cfa1f7f669e",
".git/objects/ee/59422b7d44465c571a90db05abbb1eb74375df": "ea7c4c44cd87e1dc0a347917ccbc46b5",
".git/objects/ef/9150917c24c3576e8e4b1289e6b1eee3a3e35e": "ab31cf6ecbafaf0781d3d49911d400ea",
".git/objects/f0/9c0598d58c184d948a90cb2ff4986e423cc451": "2e8c9db85e6ad187d23d09e293121f58",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/fb2a512639e5e1449e417eaa60665faccd82f9": "8adfc6e164bf25f46e47a28bd651430d",
".git/objects/f9/889d0a16ede57dd48a1e868ec2782f9d65fbf5": "7e8598b283b35fbb4390e7dbebac368d",
".git/objects/fa/fb868827d9d20a1d67cece1e088765625cc4a8": "370e7af96ffc3902340d44ce5e250d4e",
".git/refs/heads/janu": "484b9032b27a9271f86132a4a044e5a2",
".git/refs/remotes/origin/janu": "484b9032b27a9271f86132a4a044e5a2",
"assets/AssetManifest.bin": "8b334aa69b56bf474394f066a4d5a486",
"assets/AssetManifest.bin.json": "faa019efbf84b02bb6c133b2301f3e2c",
"assets/AssetManifest.json": "f33a71d8b6a24389d30741e074f2042b",
"assets/assets/font/Metropolis-Bold.otf": "dea4998b081c6c1133a3b5b08ff2218c",
"assets/assets/font/Metropolis-ExtraBold.otf": "d7eaa8ab58ec03f16c8d08389711f553",
"assets/assets/font/Metropolis-Medium.otf": "f4bca87fd0d19e61c27dc96299c75f8c",
"assets/assets/font/Metropolis-Regular.otf": "f7b5e589f88206b4bd5cb1408c5362e6",
"assets/assets/font/Metropolis-SemiBold.otf": "2556a4f74e2c523893e6928d6e300f1c",
"assets/assets/img/add.png": "30050b9e7d1342d3e70710a01c90276e",
"assets/assets/img/app.png": "f305703f92319bdcc7429f7aae49e062",
"assets/assets/img/AppIcon.png": "f305703f92319bdcc7429f7aae49e062",
"assets/assets/img/btn_back.png": "d5d051d62d275e26c5d8e9623a945bb7",
"assets/assets/img/btn_next.png": "50dda2a8413e43d80bb202c7740dce0a",
"assets/assets/img/busy.png": "25a0dfd7237b6d966003ad6ab18beaad",
"assets/assets/img/cash.png": "1f953031db18576610af7e8b09b4b361",
"assets/assets/img/check.png": "8eedeb57cb76dd63a10eaef427bc2c16",
"assets/assets/img/dropdown.png": "f0cd9937947a5be83d9e3690b6f9694c",
"assets/assets/img/end.png": "4bdbdaf172add5fdd81279f30519afe3",
"assets/assets/img/facebook_logo.png": "38202a021ac69951688cb61c6b669cc1",
"assets/assets/img/favorites_btn.png": "b6cce0c82b80619b432f7baf08f5e2c7",
"assets/assets/img/favorites_btn_2.png": "18038c4ef8cef8aeff5dc345f2e8d850",
"assets/assets/img/fav_icon.png": "9330377d64d94e291bb4e5343a385f46",
"assets/assets/img/google_logo.png": "adf58f1117060bc2ee5f7e676b57e2e3",
"assets/assets/img/image.png": "b11ff6cbbdd5ed890a5df698c93a0022",
"assets/assets/img/item_2.png": "87cb7a81906bff21669c7cc498708936",
"assets/assets/img/location-pin.png": "edde02cc535c74f423497db7368316b2",
"assets/assets/img/map_pin.png": "6f2dde54c401296d3b836230b5b06eb5",
"assets/assets/img/menu_1.png": "34ffb6b9bd0c4d16eabe91d0b0abb4c3",
"assets/assets/img/menu_2.png": "e456f6b030f23adf92540cf5b5bd6161",
"assets/assets/img/menu_3.png": "d3f186bd5704103fc7ca8db74cd9a687",
"assets/assets/img/menu_4.png": "0c4d6d79e88aed0ad4f11fab0bc3a63c",
"assets/assets/img/more_inbox.png": "95abf30ae25ac6b0682b6d23ea71885f",
"assets/assets/img/more_info.png": "4e0179efe80f77cb061e2702390561d6",
"assets/assets/img/more_my_order.png": "47aa32d5cdcfe6ad4dccdb1cbf571b17",
"assets/assets/img/more_notification.png": "84a4acaf149d46beb62fc6c4b210c02a",
"assets/assets/img/more_payment.png": "a7ee42cfee46384d3c753fa68e98d288",
"assets/assets/img/on_boarding_2.png": "5ed08e841fd3a2cac39aeea92f23a51f",
"assets/assets/img/on_boarding_3.png": "60b14f09f936fdc6ca5f44c05b29252c",
"assets/assets/img/paypal.png": "b6d2295455327bf89aaa6105fa928db6",
"assets/assets/img/quickadd.png": "292a7d603cfe7482391057f48426646e",
"assets/assets/img/quickrun.jpeg": "6fcc53f0f2cdc8cdcfd641fdaec1b9df",
"assets/assets/img/rate.png": "e04aec629a857f3b0faf5e70f5b0f614",
"assets/assets/img/search.png": "6c5c30445169b17a6145fe20433c9175",
"assets/assets/img/shopping_add.png": "a25c987e9914a2ec862085b8b5797b33",
"assets/assets/img/shopping_cart.png": "71f26b74b0c34dc1deb2a08480f65a64",
"assets/assets/img/splash_bg.png": "212076bd598ba266747bc232c72063a8",
"assets/assets/img/start.png": "6d927c47a4216970da26f03c1361bb35",
"assets/assets/img/start.svg": "33ac5de5e10eda9bc0dd02cb6c6fe2ec",
"assets/assets/img/tab_home.png": "13017c54f3129efff3e1e78a57061ffa",
"assets/assets/img/tab_menu.png": "4341761a3a5ca774f1f0459cbdea8789",
"assets/assets/img/tab_more.png": "acd25cfece38c9e1b42c57e6fa5b04e0",
"assets/assets/img/tab_offer.png": "90ff0160e579a241e3110bd2e64863a5",
"assets/assets/img/tab_order.png": "90ff0160e579a241e3110bd2e64863a5",
"assets/assets/img/tab_profile.png": "f81546c894288017a0a79c06a8e4ed04",
"assets/assets/img/visa_icon.png": "b14f44ca7530d28165d68c62e25ac110",
"assets/FontManifest.json": "eb38a8cb5d0f0c5acfbb632278ac6630",
"assets/fonts/MaterialIcons-Regular.otf": "c2fbdf04b630c322bc8ed61c1db42c9f",
"assets/NOTICES": "314353fbddf8ce63c7a4b043120cf73d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "3b978fc523d9f48a5ad87b696c65e41b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "eb033000dd33a4e331d60d6521fd54cf",
"/": "eb033000dd33a4e331d60d6521fd54cf",
"main.dart.js": "ef682dc3a2cace146e6d952d90897825",
"manifest.json": "c7cf728c9af2091f6b99eff454696ae6",
"version.json": "b5ca3808dd9a1baa96fd2359d08117b7"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
