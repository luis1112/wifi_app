import 'package:wifi/docs.dart';
import 'package:flutter/material.dart';

class PageInit extends StatefulWidget {
  static String route = "PageInit";

  const PageInit({super.key});

  @override
  State<PageInit> createState() => _PageInitState();
}

class _PageInitState extends State<PageInit> {
  List<ModelTab> listTabs = [];
  ProviderConnection pvC = ProviderConnection.of();
  ProviderLogin pvL = ProviderLogin.of();
  ProviderFirebase pvF = ProviderFirebase.of();
  UserModel? user;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      user = await UtilPreference.getUser();
      if (user != null) {
        pvL.user = user!;
        pvC.initListen();
        pvC.initChanel();
        pvC.initVelocity();
        pvC.initSignal();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvL = ProviderLogin.of(context, true);
    pvC = ProviderConnection.of(context, true);
    pvF = ProviderFirebase.of(context, true);
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    listTabs = [
      ModelTab("Conexión", const PageConnection()),
      ModelTab("Externo", const PageExternal()),
      ModelTab("Intensidad", const PageVelocity()),
      ModelTab("Test Velocidad", const PageTest()),
      ModelTab("Canales", const PageChanel()),
      ModelTab("Señal", const PageSignal()),
      ModelTab("Puntos de acceso", const PageAccessPoint()),
      // ModelTab("Informe", const PageInform()),
    ];
    return DefaultTabController(
      length: listTabs.length,
      child: Scaffold(
        drawer: const DrawerNav(),
        appBar: AppBar(
          title: const Text("WIFI"),
          backgroundColor: Colors.blueGrey[900],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.green,
            indicatorWeight: 3.0,
            tabs: List.generate(listTabs.length, (index) {
              var item = listTabs[index];
              return Tab(
                icon: item.icon == null ? null : Icon(item.icon!),
                child: Text(
                  item.title.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),
          ),
        ),
        body: TabBarView(
          children: List.generate(listTabs.length, (index) {
            var item = listTabs[index];
            return item.child;
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: itemFloatingActionButton(),
      ),
    );
  }

  Widget? itemFloatingActionButton() {
    if (!pvC.wifiConnected) return null;
    return BtnC(
      title: pvF.isTransfer ? "Sincronizando ${pvF.formatMinutes}" : "Guardar información",
      onTap: () {
        pvF.initSave();
      },
    );
  }
}

class DrawerNav extends StatefulWidget {
  const DrawerNav({super.key});

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  ProviderLogin pvL = ProviderLogin.of();

  @override
  Widget build(BuildContext context) {
    pvL = ProviderLogin.of(context, true);
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if ((pvL.user.photoUrl).trim().isNotEmpty) ...{
                    CircleAvatar(
                      child: Image.network(
                        pvL.user.photoUrl,
                        errorBuilder: (_, __, ___) {
                          return Container();
                        },
                      ),
                    ),
                  } else ...{
                    CircleAvatar(
                      child: Text(
                        obtenerIniciales(pvL.user.names).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  },
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          pvL.user.names,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          pvL.user.email,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Column(
                  children: [
                    itemDrawer("Informes", Icons.exit_to_app, () {
                      navG.popAndPushNamed(PageInform.route);
                    }),
                    itemDrawer("Salir", Icons.exit_to_app, () {
                      pvL.navigatorExit();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemDrawer(String title, IconData icon, Function onTap) {
    return ListTile(
      onTap: () => onTap(),
      title: Text(title),
      leading: Icon(icon),
    );
  }

  String obtenerIniciales(String? nombreCompleto) {
    if (nombreCompleto == null) return "";
    if (nombreCompleto.trim().isEmpty) return "";
    List<String> partes = nombreCompleto.split(" ");

    String inicialNombre = partes.isNotEmpty ? partes[0][0] : '';
    String inicialApellido = partes.length > 1 ? partes[1][0] : '';

    String iniciales = "$inicialNombre$inicialApellido";

    return iniciales;
  }
}

class ModelTab {
  String title;
  Widget child;
  IconData? icon;

  ModelTab(
    this.title,
    this.child, {
    this.icon,
  });
}
