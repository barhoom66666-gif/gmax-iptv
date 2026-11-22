part of '../../screens.dart';

class PlayListSetting extends StatefulWidget {
  const PlayListSetting({super.key});

  @override
  State<PlayListSetting> createState() => _PlayListSettingState();
}

class _PlayListSettingState extends State<PlayListSetting> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: ProgressRing());
        } else if (state is AuthSuccess) {
          final currentUser = state.user;

          return FutureBuilder<List<UserModel>>(
            future: AuthLocale.getListUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final users = snapshot.data;

                return ListView.builder(
                  itemCount: users!.length,
                  padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  itemBuilder: (_, index) {
                    final model = users[index];
                    final bool isCurrent =
                        currentUser.accountName == model.accountName;
                    return CardPlaylistTile(
                      selected: isCurrent,
                      model: model,
                      onDelete: () async {
                        context.read<AuthBloc>().add(
                            DeleteUserEvent(accountName: model.accountName));

                        //close dialog
                        Navigator.pop(context);
                        if (isCurrent) {
                          context.goNamed("/");
                        }
                      },
                    );
                  },
                );
              }

              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
