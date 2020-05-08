


## Getting Started



### Clone the repository



### Install a recent Ruby version



using [rbenv](https://github.com/rbenv/rbenv):



```shell
rbenv install 2.5.1
```



### Install dependencies




```shell
bundle
```



### Set environment variables



Create a `.env` file in the root directory, with the following format:

    CONTENTFUL_ACCESS_TOKEN: <provided access_token>
    CONTENTFUL_SPACE_ID: <provided space_id>


## Serve



```shell
rails s
```
## Run the tests

```shell
rspec
```