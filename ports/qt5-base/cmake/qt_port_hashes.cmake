#Every update requires an update of these hashes and the version within the control file of each of the 32 ports. 
#So it is probably better to have a central location for these hashes and let the ports update via a script
set(QT_MAJOR_MINOR_VER 5.12)
set(QT_PATCH_VER 5)
set(QT_UPDATE_VERSION 0) # Switch to update qt and not build qt. Creates a file cmake/qt_new_hashes.cmake in qt5-base with the new hashes.

set(QT_PORT_LIST base 3d activeqt charts connectivity datavis3d declarative gamepad graphicaleffects imageformats location macextras mqtt multimedia networkauth
                 purchasing quickcontrols quickcontrols2 remoteobjects script scxml sensors serialport speech svg tools virtualkeyboard webchannel websockets
                 webview winextras xmlpatterns)

set(QT_HASH_qt5-base                9a95060318cadfcd6dace6b28353fa868a8dcfe9def0bd884edf7d9f72606bae625de0269323a94b81d594a6c398106c266304106329b79c7dae4e5b88269660)
set(QT_HASH_qt5-3d                  8cc23417b4a41bf9d19052e05c7e3be8773be062f1f5998a7784573ef9c35a04da50ce67a65b3709065bb3cf243aac8ede4bea60f0420a5400cbe6c9c7bdf05b)
set(QT_HASH_qt5-activeqt            6233bb64ca45b6b0065afa50a3082c6df7e4e20d36040dfaf391e02876f50c41ec293db79a13636aeae9469deefad35ced42902548f9fcd78476359ad4450bee)
set(QT_HASH_qt5-charts              a3ba8c6a606430cd87f85661116dbb2692e0bb472f0a73310aca1950f4437563d04ee950437a48a399b1a4881dd264cd1e6fdd4f30b6c3110704ec48d1467da1)
set(QT_HASH_qt5-connectivity        96cdb27aa0e439094e3f1de0c7a680973c3ce2c65bbbff38affe25a3708c9e4e3c1c6a403d698303f77a5f261b44ac657e01a769b62a1565e0a8c64c8ac80bd5)
set(QT_HASH_qt5-datavis3d           7911d911678827ca4a704b824b8841c8e8508484fb83265d4d05e64787ac1184387b9ed0870090b3233c736f5e484adc7776ba12a1173da0fceeaac46845c6f4)
set(QT_HASH_qt5-declarative         026c5024c06e44b6e91099d1ee912f38017f314ae0125227010d25d733447c692299cc7c47edc1a4bf39366a9c9c9fe77d3a249905f2ae982d0725317d824b9b)
set(QT_HASH_qt5-gamepad             bc4148bb75de53dd0885fc25ce7d679d7a5426a23ce9c93482fd11e8d6003cebe4c958fc07f17817a43f1d4449756deff24c0350fd33e100aeb2c302c650ae33)
set(QT_HASH_qt5-graphicaleffects    489a308af5f56ff2b023375ddf705f8a1b15c0e1fb1ec3bc6e5f66a80b5863d63aa0e57a3aef025ab965694add8d71424123bca120ce8d8b8448e7218f7fc640)
set(QT_HASH_qt5-imageformats        9fa76b7eec083596c45f68642b49dc88c2759a28cb9359935c3a64604082acea9adecee49bb0828cc587b86d469aec7169f8f72f83a15194c4fc10f0ca25fae0)
set(QT_HASH_qt5-location            fe82194e4e6bc2a2e6e3c55e3360afdfd56a6495a8d87bfbdceb29255430954d4c1adc62f1f82e63b23778f0bf03b0a50d6f5d2a963bd786f2cf2fbed7450ccc)
set(QT_HASH_qt5-macextras           80779bf9c49ff89b866327a3358cede9308c41d6a49d8d6aa29661f4ad98d191c2f68d9af0d89be36fe54d094972f7a7689ecc26bc2bfcf53e9be1305e107178)
set(QT_HASH_qt5-mqtt                3167de873dc3d42607440237c7b341c270079a1edd72588ebe95082ab209bbd24496d60d41c87ade166b595fda924a52cb2ff0efd05b48aa4c77c7b51b125f36)
set(QT_HASH_qt5-multimedia          a59983d887c8de462399fd53beb640c1b865c17f8b1a83635c2e1d27903861dd588eb64935d7c02d733c51c9a21174065e70a5fc1aa78600e5540c489b7695a3)
set(QT_HASH_qt5-networkauth         d7849518614a7bdb2ddbcf92b773f5e7c26f1af4ba07f0304b4634ed69bf3c17798509d28af2c49aba0cfad35a1cad5bda27acdbde3aa8d86038efeb9f5001e0)
set(QT_HASH_qt5-purchasing          b9f7e43cf4a8e23bc167d2473fa6f8af47455f066b584daf18d97d4a67dd766aaf17c7b897b2bae20cf636253174430be664815e1e86aeb07ed870bb2969ad0d)
set(QT_HASH_qt5-quickcontrols       4539a6ce1ee20f71f6bf48271bc3fe1125bd21899cf36142d1c3d41a68ba56211f27d6e4403c69e86bd4698c7c7c79bc60f2a78ef1b19c5eab5b8690d1a01037)
set(QT_HASH_qt5-quickcontrols2      afbd742783d83eabf182031e218c2f611709cd66f2b4886317bd356ffff2afabe820e1f552f478a0c3f74daf6fd1f5256900448f5445b84792d6a71b42ccd20a)
set(QT_HASH_qt5-remoteobjects       ed3314b1c66f9375bdc101029eaf730a630157ee41c094de2ff9cc5340c3c92a781dcb2b2cf0b8bbad8b19e566fb80f2d3b76e58624e990f90f23b8cdd21bd54)
set(QT_HASH_qt5-script              a422e47873ddf4c84adf00f51b721465acedfac535b0daeede63eac0d41c6f4f07d5a5f86513c86e981f3a0024020be03730670befab2a20cd4d6564c98d6c90)
set(QT_HASH_qt5-scxml               23d340994af3e217ae58698dd0cd38f30d67d74a042d58cabbd0f38a6c13a8d64d6238cd6dee246ce0f99d5206bc210749941b88e5f745d3b92207eab06730b1)
set(QT_HASH_qt5-sensors             81ac74e4c0a3d1942393c9267bbcc50af0e04a6f163d566010d6053dc4c69a67395c3f4b7564a50ec84ac88a715edd002920be4e145e6bd23d082a021dee1e5a)
set(QT_HASH_qt5-serialport          f3a5fb8c9a9513c16f52bd22b4fd4c6400819863237762f459d9f612ef2457447733cc8ed2bd645f182ab9eab6ddb5bcdbca2fbd67745def1a5fad1392087f4e)
set(QT_HASH_qt5-speech              2a1a2c86ee3b5501623bb0c2c8e5b6f96b353707fe0eb804629187899eca5952c665ef037c4257f635edf34ddea03bc686f472a4a346d9f8e2adc7479f640482)
set(QT_HASH_qt5-svg                 3d7f89d106b36c8a0fd04c6e6f0ccde0c50ced7192980ea7d9330ba73d9307559e60ed2b10c28481a419d19aaae6609bde9e1dd74ccedf340dacf0194a60429d)
set(QT_HASH_qt5-tools               e88af049ad9261720bc44ff9030113179d9429eaf073bed45115decd520ecf5d3ca860983f012bac189310ce9f3826b1fcb484faadb4f6d0b16c67c0d998f34c)
set(QT_HASH_qt5-virtualkeyboard     e4581673451c40bf39b9793b0131bbad29e8a3f9db2d42adb23b48847bd674b6820717c051b76e506d4fd52e87c79b042533be85285a0cce9bcdc49cca964e66)
set(QT_HASH_qt5-webchannel          8ea543f29e8f686961b033c1246714b1535d0be730026bef4b4ee172ce602c706d8a16b8391510a302df7be6545007a2f42311eb1aea4da326c3addde16ca2b2)
set(QT_HASH_qt5-websockets          970ad232ad1258630404d5e7347721505a780497e1775f88591098f11bca48cbf62c4f02491b133d31e4304eb9e16f923292c5b778e22d530d7a5a4e95d422ba)
set(QT_HASH_qt5-webview             310beedf88cefc05458e99838e7cb71971aa24ba6c460ff3da804c2ab7f56167ca1067ddca71ee29ced32ea974fe405261f24c8bbcac0c7b69063d7c4e38a4de)
set(QT_HASH_qt5-winextras           053ca5f60c7946f6409ef34094b4a7d1431039407a5195e539e8edfda795da20fc695ceec58ae0df15e4dcc597047518d06a424d11fb4aaf6ae82f1d4badab33)
set(QT_HASH_qt5-xmlpatterns         30b25e152970bfe51fcdeffa43d11dd51496e5ea6a5da644b13fa0ce4835302ebec651c1ecdcf9590c6689598cea9bd63748aab4ee0ec69f9155dc310a7c04c3)
set(QT_HASH_qt5-x11extras           1e83c2d350f423053fe07c41a8b889391100df93dd50f700e98116c36b3dbad9637a618765daf97b82b7ffcd0687fc52c9590d9ce48c2a9204f1edc6d2cae248)

if(QT_UPDATE_VERSION)
    message(STATUS "Running Qt in automatic version port update mode!")
    set(_VCPKG_INTERNAL_NO_HASH_CHECK 1)
    if("${PORT}" MATCHES "qt5-base")
        foreach(_current_qt_port ${QT_PORT_LIST})
            set(_current_control "${VCPKG_ROOT_DIR}/ports/qt5-${_current_qt_port}/CONTROL")
            file(READ ${_current_control} _control_contents)
            #message(STATUS "Before: \n${_control_contents}")
            string(REGEX REPLACE "Version:[^0-9]+[0-9]\.[0-9]+\.[0-9]+[^\n]*\n" "Version: ${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER}\n" _control_contents "${_control_contents}")
            #message(STATUS "After: \n${_control_contents}")
            file(WRITE ${_current_control} "${_control_contents}")
        endforeach()
    endif()
endif()