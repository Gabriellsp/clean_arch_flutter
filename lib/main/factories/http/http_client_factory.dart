import 'package:clean_archtecture/data/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:clean_archtecture/data/usecases/remote_authentication.dart';
import 'package:clean_archtecture/infra/http/http_adapter.dart';
import 'package:clean_archtecture/presentation/presenters/presenters.dart';
import 'package:clean_archtecture/ui/pages/pages.dart';
import 'package:clean_archtecture/validation/validators/validators.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
