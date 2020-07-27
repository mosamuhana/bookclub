part of 'signup.view.dart';

class _SignupForm extends StatefulWidget {
  const _SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ShadowContainer(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: t.secondaryHeaderColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _username,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'Full name',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _username,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: 'Confirm Password',
            ),
          ),
          SizedBox(height: 20),
          RaisedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {},
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginView()));
            },
            child: Text("You have an account? login here"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
