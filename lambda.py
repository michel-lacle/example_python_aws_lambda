def my_test_function(event, lambda_context):

    print('event')
    print(event)

    print('lambda_contect')
    print(lambda_context)

    print("hello world")


if __name__ == "__main__":

    my_test_function("a", "b")



