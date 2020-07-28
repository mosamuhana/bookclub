part of 'signup.view.dart';

final _loginButtonStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

class _SignupForm extends StatefulWidget {
  const _SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _fulName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();

  //bool _valid = false;

  @override
  void initState() {
    super.initState();

    //_fulName.addListener(_onChange);
    //_email.addListener(_onChange);
    //_password.addListener(_onChange);
    //_passwordConfirm.addListener(_onChange);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ShadowContainer(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () {
          print('Form onChanged');
        },
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
              controller: _fulName,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'Full name',
              ),
              validator: (v) {
                if (v.length == 0) {
                  return 'Full name required';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: 'Email',
              ),
              validator: (v) {
                if (v.isEmpty) {
                  return 'Email required';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _password,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: 'Password',
              ),
              validator: (v) {
                if (v.isEmpty) {
                  return 'Password required';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordConfirm,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: 'Confirm Password',
              ),
              validator: (v) {
                if (v.isEmpty) {
                  return 'Confirm Password required';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Text('Register', style: _loginButtonStyle),
              ),
              onPressed: _onSubmit,
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
      ),
    );
  }

  void _onSubmit() async {
    //if (!_formKey.currentState.validate()) return;

    final email = _email.text;
    final password = _password.text;

    print('SUBMIT email: $email, password: $password');
    final ok = await Locator.auth.signUp(
      email: _email.text,
      password: _password.text,
    );
    print('Signup ok: $ok');
  }

  @override
  void dispose() {
    _fulName.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }
}
