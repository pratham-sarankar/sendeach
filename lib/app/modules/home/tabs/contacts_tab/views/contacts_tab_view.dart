import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ja/app/data/extensions/contact_extension.dart';

import '../controllers/contacts_tab_controller.dart';

class ContactsTabView extends GetView<ContactsTabController> {
  const ContactsTabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: false,
        bottom: searchField(controller),
      ),
      body: Column(
        children: [
          Expanded(
            child: controller.obx((state) {
              if (state == null) {
                return Container();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: state[index].imageProvider,
                    ),
                    title: Text(state[index].name),
                    subtitle: Text(state[index].phoneNumber),
                  );
                },
                itemCount: state.length,
              );
            },
                onLoading: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  PreferredSize searchField(ContactsTabController controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: CupertinoSearchTextField(
          controller: controller.searchController,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Get.context!.theme.scaffoldBackgroundColor,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          style: GoogleFonts.poppins(),
          onChanged: (value) {
            controller.search(value);
          },
          placeholderStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          prefixIcon: const Icon(CupertinoIcons.search),
          suffixInsets: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          prefixInsets: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        ),
      ),
    );
  }
}
