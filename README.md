# my_mvvm_app

A simple Flutter application with MVVM.

This app offers several functionalities:
1. Secure Login: Users can log in through a dedicated login page.
2. Paginated Product Listing: Products are displayed in a scrollable list with pagination, allowing for efficient browsing of large datasets.
3. Complete CRUD (Create, Read, Update, Delete) for Products: Users can create new products, view existing ones, update product details, and even delete them.
4. Dedicated Profile Management: A profile page provides user with options to logout.

## API

This project is using dummy APIs from [Dummy JSON](https://dummyjson.com).

You may refer to https://dummyjson.com/users for valid credentials.


## Running the project for the first time

1. Install all required dependencies for the project

    <details>
	
	```
	flutter clean
	flutter pub get
	cd ios
	pod install
	```
	
    </details>
    
2. Set up your .env files.
    
    <details>

	<summary>For a new project</summary>

	If this is a brand new project, create the following files in the `lib/config` folder:
	```
	config
	|- .env.development
	|- .env.production
	|- .env.staging
	```
	Then, update all three `.env` files to include the following lines of code:
	```
	BASE_URL = "www.google.com"
	API_KEY = "HELLO THIS IS DEV API KEY"
	API_SECRET = "DEV API SECRET"
	```
	
	</details>

    <details>

	<summary>For an existing project</summary>
	
	Retrieve the existing `.env` files and paste them into the `lib/config` folder.
    </details>
    
    <details>

	<summary>After adding the `.env` files</summary>
	
	Generate `Env()` by running these commands:
	```
	flutter pub run build_runner clean
	flutter packages pub run build_runner build --delete-conflicting-outputs
	```
	If you have `development_env.g.dart`  `production_env.g.dart` and `staging_env.g.dart` files in the `config` folder, you are on the right path.

	</details>

3. Run the project

## Notable Dependencies

To effectively work on this project, it's essential to have a good understanding of the following Flutter dependencies. Here are the links to their respective pub.dev pages for additional reading and documentation:

1. Local database - [isar](https://pub.dev/packages/isar)
2. Environment variables - [envied](https://pub.dev/packages/envied)

## Project Structure

<img align="left" style="margin-right: 20px;width: 325px" src="screenshots/folder_structure.png"></img>

### Entrypoint

Refer to `main.dart` and `app.dart` to configure project startup settings.

### Project Folders

#### `assets` folder

The files here include `images`, `icons`, `app icons` and `fonts` files.

#### `apis` folder

Contains the API functions being used in this app.

#### `config` folder

Contains the app configuration. For confidentiality purposes, this file is not in remote repositories. Do request this file from the developer.

#### `constants` folder

Contains properties or values that are commonly used in this app.

#### `extensions` folder

Contains convenience methods for working with DateTime, ScrollController, etc.

#### `models` folder

Common models being used in this app.

#### `services` folder

Contains important services being used in this app.

##### `database service`

Service for local storage.

##### `locator service`

Service to setup locator. Here is where you register singletons for other custom services.

##### `navigator service`

Service to store navigator state global keys to allow contextless navigation whenever necessary.

##### `network service`

Service for API call.

##### `secure storage service`

Service to persist data that needs to be stored securely

#### `settings` folder

Contains files used to configure app settings.

#### `utils` folder

Contains reusable functions used for this app.

#### `view models` folder

Contains view models used for this app.

#### `views` folder

Contains views used for this app.

#### `widgets` folder

The folders here should be for widgets that will be commonly used for the entire project.

**Example:** Text fields, buttons, dialog boxes, snackbars etc.

