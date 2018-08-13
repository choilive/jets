---
title: Polymorphic Python
---

Polymorphic support for python works like so for the controller code:

`app/controllers/posts_controller.rb`:

```ruby
class PostsController < ApplicationController
  python :python_example
end
```

You add your corresponding python code in the `posts_controller/python` folder:

`app/controllers/posts_controller/python/python_example.py`:

```python
from pprint import pprint
import json
import platform

def lambda_handler(event, context):
    message = 'PostsController#python_example hi from python %s' % platform.python_version()
    return response({'message': message}, 200)

def response(message, status_code):
    return {
        'statusCode': str(status_code),
        'body': json.dumps(message),
        'headers': {
            'Content-Type': 'application/json'
            },
        }
```

Notice, how with the python code, you must handle returning the proper lambda proxy structure to API Gateway.

## Default Handler Name

The default handler name is `lambda_handler`. This can be changed with the `handler` method.  Example:

`app/controllers/posts_controller.rb`:

```ruby
class PostsController < ApplicationController
  handler :handle
  python :python_example
end
```

The python code would then look something like this:

```python
def handle(event, context):
  ...
end
```

<a id="prev" class="btn btn-basic" href="{% link _docs/polymorphic-support.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/polymorphic-node.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>