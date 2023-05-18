pragma solidity ^0.8.17;

import "../../bw6761/G1.sol";
import "../../bw6761/G2.sol";

struct RVK {
    Bw6G1Affine g1;
    Bw6G2Affine g2;
    Bw6G2Affine tau_in_g2;
}

contract KZFParams {
// KZG Params RVK: RawKzgVerifierKey {
//     g1: (4899669911220870824804739403742284678426886510209816466540162631481837169264997750189618981439161010001152950605086136310546447337107125823474648863601042926150304752752915047030837962028781994140314184647528107150139718709000794, 774513518739540342724174398414823150296944057583435643402147625478031553578602691027792430183556587462263268927379605549424049816384259652614562214015220754054122558113556336533153765215220826809342815149422119040577821352936451),
//     g2: (5338335751266063985976824771702338561218362285631029538619415061363645197332188556762035402136671397963160194291882086997644170151048646440505001405368718533324875474606714926304084863699927106301893175260469110184825101302102571, 133501765765310151603755575096797893373160111380334097565325828603277976089260850971641632891725960874997519561525911525818331149887470230335787968294609029738073048807804001850808485248289847944504520383791166632228912026778737),
//     tau_in_g2: (3215585473287955423610061430432539674291406131002667104122435455631246110517857744313322216618693129177112325774027601744668183680014357653068385889413455999660225239956087383104705903865806152419448174197239241259627676821246572, 5115809734488003118464911241221034288141817635213403148447203369464828676665855496254280704959931745548278796037849086813821359202583364439934807628202062446911076642695617282204079919929029155984355559667475933797997142174327159),
// }
    function raw_vk() public pure returns (RVK memory) {
        return RVK({
            g1: Bw6G1Affine({
                x: Bw6Fp({
                    a: 0xced40f3fc08a0df72f075f1372a205ecaf8753d9880232ef8d819f925e815e,
                    b: 0x78c17205e5ad6e4b169d8b4961e0cb61a7e79d37665ffdd49e44a67a582fe12e,
                    c: 0x4154e8bca4e2e42d774cf572481f3e040c07f15333099e0849d5903ca01fba5a
                }),
                y: Bw6Fp({
                    a: 0x20b1bebac8b11e4fa226cd871f88ca2b04ac320da17c83573a0512db55fed4,
                    b: 0xc6d80dbbba4ac4b67bf59140b6f509ced3f1b4530706ac7e0e5642383d2b7b9c,
                    c: 0x8e4dd093d1b938da474d5da47796b4c8831a4ae0d4366519574ac860dbbc4403
                })
            }),
            g2: Bw6G2Affine({
                x: Bw6Fp({
                    a: 0xe1587b628b0c186657f8f9a1607324aa063e21297bb041429583d9760988a4,
                    b: 0xd79621843cc6065599e88c2e21efbf1aabae59d8cb85b5b656d04085114e230e,
                    c: 0xbe51c44da3a09daf276eac4858845c458857040c3b7e3ada29a7402370c7fa2b
                }),
                y: Bw6Fp({
                    a: 0x5a2ae4569ffb7e38958e9351fd508728c78152bdfb904d075090ba00b8a11,
                    b: 0xa11252415a6469b615974a59efee8b19bf27140f87a9d9e11613930e1b065948,
                    c: 0xe83d56e8a4ce45043f05d1d565f7ae081fa8369ded934af4fbc1a173104e7c71
                })
            }),
            tau_in_g2: Bw6G2Affine({
                x: Bw6Fp({
                    a: 0x87bd13edeea1bc699a8fdd23f55f292d85221fb0b47602ba337e03b3d8ac1c,
                    b: 0xc0267f2bea8e36d07ad6c5fedac48820fdac9a1722bf9e5cfa1bd8247ad1ee68,
                    c: 0x1f9e6b254f55460892263cc33a098f7338674ce1995b133dc6b660eb1c4e526c
                }),
                y: Bw6Fp({
                    a: 0xd7f3c3c45b617d381a0382f62e274cd3962aa328d13704bb6025b80d4ef173,
                    b: 0x604fe6cc1ef9a8f8626aa8d03f497494ea8c0ff30fe77c0fbfa0f362fd9643e3,
                    c: 0x75817b71a89216c125aa6b9110b082286846941f0c7640be426a06a93467e177
                })
            })
        });
    }
}