from django.shortcuts import render, redirect
from .forms import RegisterForm
from django.contrib.auth import get_user_model

def register(request):
	if request.method == "POST":
		form = RegisterForm(request.POST)
		if form.is_valid():
			form.save()
			return redirect("/")
	else:
		form = RegisterForm()

	return render(request, "myapp/register.html", {"form": form})


def list_users(request):
	User = get_user_model()
	users = User.objects.all()
	return render(request, "myapp/users.html", {"users": users})