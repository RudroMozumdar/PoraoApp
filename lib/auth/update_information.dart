import 'package:porao_app/common/all_import.dart';

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({super.key});

  @override
  State<UpdateInformation> createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  final TextEditingController _controllerExperience = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();
  final TextEditingController _controllerSubject = TextEditingController();
  final TextEditingController _controllerSalary = TextEditingController();

  // Upload Picture Field
  Widget _uploadPicture() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: IconButton(
        iconSize: 30,
        onPressed: () {},
        icon: const Icon(
          Icons.file_upload_outlined,
          color: Colors.black,
        ),
      ),
    );
  }

  //Experience Field -------------------------------------------------------------
  Widget _experienceField() {
    return CustomTextField(
      hintText: "Experience",
      prefixIcon: const Icon(Icons.auto_graph_rounded),
      borderRadius: 40,
      controller: _controllerExperience,
    );
  }

  //Prefered Location Field -------------------------------------------------------------
  Widget _locationField() {
    return CustomTextField(
      hintText: "Prefered Location",
      prefixIcon: const Icon(Icons.location_on_outlined),
      borderRadius: 40,
      controller: _controllerLocation,
    );
  }

  //Prefered Subject Field -------------------------------------------------------------
  Widget _subjectsField() {
    return CustomTextField(
      hintText: "Prefered Subject",
      prefixIcon: const Icon(Icons.menu_book_rounded),
      borderRadius: 40,
      controller: _controllerSubject,
    );
  }

  //Salary Field -------------------------------------------------------------
  Widget _salaryField() {
    return CustomTextField(
      hintText: "Minimum Expected Salary",
      prefixIcon: const Icon(Icons.attach_money),
      borderRadius: 40,
      controller: _controllerSalary,
    );
  }

  // Update Info  Button ----------------------------------------------------
  Widget _updateInfoButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shadowColor: const Color.fromARGB(255, 61, 61, 61),
        minimumSize: const Size(double.infinity, 63),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: const Color(0xFF77258B),
      ),
      onPressed: () {},
      child: Text(
        'Update Information',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: primaryFont,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 178, 134, 255),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          title: "Update Information",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Text(
                  "Upload your pictures",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _uploadPicture(),
                    _uploadPicture(),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Add your experience in teaching field, preferred location, subjects and minimum expected salary",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                _experienceField(),
                const SizedBox(height: 15),
                _locationField(),
                const SizedBox(height: 15),
                _subjectsField(),
                const SizedBox(height: 15),
                _salaryField(),
                const SizedBox(height: 15),
                _updateInfoButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
