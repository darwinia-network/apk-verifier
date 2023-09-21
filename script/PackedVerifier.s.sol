// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/PackedVerifier.sol";
import "../test/common/PackedInput.t.sol";

contract PackedVerifierScript is Script {
    function setUp() public {}

    // 0x220680420000000000000000000000000000000000000000000000000000000000000b00006ff133c54b70d73a290896c028c511f071093db38b576ba3b094a33de896ce063e7b97610b3eda144cacfe44bf5a73f3dbaabe06399c3759a4942ea0377052d968e9f5cd3bf1e80de678bc32f2e2ac7e29528667129ba1956753165420e561004982772a26252e29d42b88940198394085cb34fc32b7c64ab2b6426da8fb67a4ee72ac3286bc1ef300af56312233f5f03085abcac859dfd5aca0cf6ead212b69131f49bf7fc36a67263489a5ce79f27710c5e81d5099a02910d54b0bbf236f00d10ba796089ac633dc6b884fe6f065fd633281ac5ec8703bb870ba2fb1c2990d696f2b81e9edc75ca05c755905632417cbdedc817998ecbcdf96a44e805ddf883509b33e6d2c317d9093e82e0d8e52939a37b0e088c29048ddd9762e5e17f700ef9b9632f0eb98c6274788b1c7082020bba26223a512c631a4e02d30f005954ae54f9aa01a90d9742b33b8ef43f4b2092e8c9e008c43695373691b4f77a4a304a98431231ea88af3e0a32fedc2dadd63d0b08adc12fe4ae14521d7e42358f300d7225a283604bc06b9d7051015fb7c8efbf29a404290946c9bf5bbc7a6fa67223bfb16f73c7b366370318f7e7572b5e6b83cae669f753282b000a3fa92b8ea7f43285fd3f43d4b2a7600d80966c45f6929a1b5bc5b2a85631b000e3a6e7310008f7c0a3be452bd8badf2bc98d8f530aa1b933219b20037461476cacf25c4eed04bbc6dde82f43d2f3ca41207815455025d626c23d19c160e06d7fa7570e4be2b498590684ff4cb7c4026f153685bf18ed80ab295b159c34930b64e14ae0cce00586266ad04839b3d8a20e32efa761e3d2d76a356da2d3d312638e1b47289333209916d024075f994e0a61bab7e49ab874f1aaf3cd5a2aa3bba743520d5cde49ab77d2d9245e50d58e9c213b67e39e61a633dc47e97bbc902221c6264a3fa5e00dab76fb60fff8b168649e061b3da2b8fedf09058d7616cfc953c9d03f3acd29a1e56d993e87e39f5ca095d8a6f0b827e8d4cc151ac1d215b04c642ac1a4faaf9e8636f2d4361fb487bdd3001abc66e78c316b27c72a16581db971f3ab7279100ccf78a8c21c1d1c2578608ab8e87958e52692a369b5286c38b9d5595f22652b2961b9ef4bcf1ae5b9ca266ade1e59978e3b429614c554a95dc0dae2e62cf3e5061872adf0a7cae0ffa81b5b0ce5c4ef6d6f45d4411f8243628feacb3528a0f007666bbfb2c76a43b8d9ecd876c6b7aad80c2bc099af88c77423e1b8ff79105e6476d6c322c42f21b54471135682c3560e02131fea55e05f49c6d6ce147c1b33ebc5034414706996814924e467ee9959341b8494c99e4bc8e179565b91669e9000c062e7124594105229e1e2fbc071de6c3776b78bc4c6c7901e6c81be5914bebf37552e44d4eb021a50d5a4bc37d5e001303663cec0edf34117614d7eb256d6837740adada2434b6dfd74196ee72430ef0657f8069467a374864b7ae33c45300437529406cca44d7ea90561c2a0ad8e153f93781060c8482d5ddb211f4e53197939e56f304d0cde2cfa05af195a8fb56de7e7fb2d38715c5192d7b2e98a7a5f8bfaef6daa7e129813385107a092d7ca77fcfc97b4a41a283c3611e3ebffae0000000000000000000000000000000000074f76dfbb15bc2711496a2e6f8db1e53df4bed768f1e85ce819952ddcd3790748e17b52d19a43d68d9a17df882efb300000000000000000000000000000000008b7faae203220857bc99a92612295d1f04628098789bc4a18e48f5e5e5405047ea1513d63b86992918759d69702d730000000000000000000000000000000000451ff28beec13b8fc0911d8eee5065859712a1e38c6f3a3d3d82399205613a44d70eecc4f7415a351fe5481658026f0000000000000000000000000000000000c9a6b13bba9c18c2718e8bc5c7e16256af8f3978499d6994dfb71f654c1ffe965cb52d28cb5f99c95ae45a684d0a0600000000000000000000000000000000017539471030fca84b49ebeab36974ad8e99484f0ccfdb70662179e2f6c6516f15d59c41cc22e0da573c6ba9506df71900000000000000000000000000000000017819b5fbeeb030889a57224564d0f524d53e06b4f88186d4ee9ce958dbccd8d7b571b4da50595488a014bc8c35e53b000000000000000000000000000000000084ca71739dc2611ccb26040c8c09e0de6ddb5d84f7ac198e54d999bc2496d51000308988b025fcdb1cf554d1f9a93700000000000000000000000000000000013390c347521f545e7f3ed7f45cc0c415c70cea16e3337a600c9bc62a2e00da64ccb9f64c5754c9112e1274cdb52245000000000000000000000000000000000051ec84dc646300c424413a51598200f97d9781fd83132b74c7bb7b8893e18acb6ed9452108906900761de1be51826c0095734f487b83d9b7ce78a0fa3eccdf10da8c06790210baffdf49be7b70fdcfd7e13bf02d472fab4aeae1b188e1cb93bf123796bc90512e1d1786b250dd529c3869986866b87f65b69101d1620d81aa8348dec3fe32a53b153cdc6cf4c416250066d28fc600f3d83535c5a124098ed340e342794dc20f6b2829716f7426ee4735cf1a0b2c151ddedb9298d8c77951c987d58063a53a968830ce9976ccfe716df61c1df0799c0e1a3aba8f0df8cce31562d639b6135cbed5a9d450ff4d112e8d001b4ce9c111cef0161348842b70f18c32380e87e957751365ac4c1646a57e72e4e7c85add8bc7d97d331643a81851f9588facfec8108127bdd9e2e94f774a1d1b4065d08dc26b68fcb68e7564442043102abd92f01471fb7f0ad1603240da0e0082a7c17fee184cb236c53d49d0afe3f9db931479f27616c8453abcf7a42f35fe23b8a2275516e069ad99aa800b0c86869192b1d74cf5202c3baf9d867b482ec4346ee735aa71c4c4505298ba88f12ec50d65c7fe3fc328e1499834368c754b0000000000000000000000000000000000e3f01ca6ff6209cfc4b5f76939854d983a2e2e7300a4c19ba84edbce27a4279be484b2a7a1943c30a72ba6f8265e22000000000000000000000000000000000079cc7b2a270ac9befcb0b47f6654afa3f9b97216acd16739ae6762473c7362f10cf8b906832bd22fe51decbed578eb00000000000000000000000000000000003b9231248eb5337b3e9f028c073efe7e015f17545cde1d30bbdc0f231d16fad24cd6716b28b3329112a9306d05c1d1000000000000000000000000000000000060fafb9c430873a186e529aae8adc707326665a45b3b656104c4eecaea70fe7f8ed13c897baadea4ade0955d6e4e390017214fa29ac9806a5730f174a0ed1e5821f8eb491841608ce8b29ff079dc952134cac3155c23a1c173764d4322edbb4ee7a275ba770623b836deac0c1e22ff77cf494a270946ea7888dba523265dc84416571fc0daec31bebec0fc8204f8a100528af0c701b93d94bc0620b0c61432a04cb0f4ed13aa479932cc9690aa34d610d9b2df89e7a972aac8b6b9e939983fd937ccbbedab777aeb7c8520617db09741a1b8dfd3bdc2ff742c0ef4094468b4e479533918057a00e4128859fb2498e500b26d4c805b675207e1280359ac671f3e493d0c779322680b368df0ac03205d1328e8691f00789856d9356805b0cd6f50f84c4be96b1d0cb3236ad02ba632ee1f22a9559fcf547b647d86bd1b260db7dd78ff26c9ae85acef71c3465375dc78003d16f8ed12a5a40226a4d9e2a1a054f1f21ed2c498a00f7523ea8fc33790f6e661d44f017e4a6f85adcf77d2eca96c60fdc9de9d665eb87d8b731ca7700711f465a60b2bd0dc8404004ef5575d20952ba2e187cc8330ae86f0366b45be7a3400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000df12686939cc8adc613aa1e2ef7753faff1467b5420ab33cf04de813d4d9ae57cd11569e1228ab3f3b77de3636a39e0000000000000000000000000000000000c7b39a036437b74c03aacbb1ed26fcab84a985e21baca9e1d873c8d7a9a8eca08ce79d32ac6edbefb8c43e7b62b6b600000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000017fdf7bffffbffbeffefffefbfdfffffffffff7ffdfb5fffe7ffffbefbfffffdf
    function run() public {
        PackedInputTest s = new PackedInputTest();
        vm.startBroadcast();
        Bw6G1[2] memory pks_comm = s.build_pks_comm();
        PackedVerifier v = new PackedVerifier(pks_comm);
        vm.stopBroadcast();
    }
}