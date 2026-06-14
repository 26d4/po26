from django.test import LiveServerTestCase
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.webdriver import WebDriver
from selenium.webdriver.support.wait import WebDriverWait
from django.contrib.auth import get_user_model


class RegisterFormTestCase(LiveServerTestCase):
	@classmethod
	def setUpClass(cls):
		super().setUpClass()
		cls.selenium = WebDriver()
		cls.selenium.implicitly_wait(10)

	@classmethod
	def tearDownClass(cls):
		cls.selenium.quit()
		super().tearDownClass()

	def test_register_ok(self):
		self.selenium.get(self.live_server_url + '/register/')
		username_input = self.selenium.find_element(By.NAME, "username")
		username_input.send_keys("myuser")
		email_input = self.selenium.find_element(By.NAME, "email")
		email_input.send_keys("myuser@example.com")
		password1_input = self.selenium.find_element(By.NAME, "password1")
		password1_input.send_keys("myverysecurepassword")
		password2_input = self.selenium.find_element(By.NAME, "password2")
		password2_input.send_keys("myverysecurepassword")
		self.selenium.find_element(By.CSS_SELECTOR, '[type=submit]').click()

		WebDriverWait(self.selenium, 10).until(lambda driver: driver.find_element(By.TAG_NAME, 'body'))

		self.assertGreater(get_user_model().objects.filter(username='myuser').count(), 0)
	
	def test_register_bad_email(self):
		self.selenium.get(self.live_server_url + '/register/')
		username_input = self.selenium.find_element(By.NAME, "username")
		username_input.send_keys("myuser")
		email_input = self.selenium.find_element(By.NAME, "email")
		email_input.send_keys("myuser@e")
		password1_input = self.selenium.find_element(By.NAME, "password1")
		password1_input.send_keys("myverysecurepassword")
		password2_input = self.selenium.find_element(By.NAME, "password2")
		password2_input.send_keys("myverysecurepassword")
		self.selenium.find_element(By.CSS_SELECTOR, '[type=submit]').click()

		WebDriverWait(self.selenium, 10).until(lambda driver: driver.find_element(By.TAG_NAME, 'body'))

		self.assertEqual(self.selenium.find_element(By.CSS_SELECTOR, '#error_1_id_email strong').text, 'Enter a valid email address.')
	
	def test_required(self):
		self.selenium.get(self.live_server_url + '/register/')
		username_input = self.selenium.find_element(By.NAME, "username")
		email_input = self.selenium.find_element(By.NAME, "email")
		password1_input = self.selenium.find_element(By.NAME, "password1")
		password2_input = self.selenium.find_element(By.NAME, "password2")
		self.selenium.find_element(By.CSS_SELECTOR, '[type=submit]').click()

		self.assertIsNotNone(username_input.get_attribute('validationMessage'))
		self.assertIsNotNone(email_input.get_attribute('validationMessage'))
		self.assertIsNotNone(password1_input.get_attribute('validationMessage'))
		self.assertIsNotNone(password2_input.get_attribute('validationMessage'))
