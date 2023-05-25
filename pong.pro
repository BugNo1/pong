QT += quick

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    common-library/gamedata.cpp \
    common-library/mouse_event_filter.cpp \
    common-library/player.cpp \
    common-library/player_tablemodel_points.cpp \
    main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=

include ($$PWD/QJoysticks/QJoysticks.pri)

HEADERS += \
    common-library/abstract_player_tablemodel.h \
    common-library/gamedata.h \
    common-library/mouse_event_filter.h \
    common-library/player.h \
    common-library/player_tablemodel_points.h

QMAKE_POST_LINK += $$QMAKE_COPY_DIR $$shell_path($$PWD/common-media/gif) $$shell_path($$OUT_PWD/);
