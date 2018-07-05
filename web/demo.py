#!/usr/bin/python

from flask import Flask, render_template, request, Response, flash, jsonify
import subprocess
import csv
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField

# App config
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = 'asd;fkja;sldkjf;alkjsdf'  # TODO: change me


class ReusableForm(Form):
  name = TextField('Ksat (m/hr):', validators=[validators.required()])

@app.route('/')
def index():
  return render_template('index.html')

@app.route('/foo', methods=['GET'])
def foo():
  form = ReusableForm(request.form)
  return render_template('form.html', form=form)

@app.route('/submit', methods=['POST'])
def loadFormPage():
  kMean=request.form['kMean']
  kSD=request.form['kSD']
  kMean_set = set(['0.01', '0.05', '0.1', '0.5'])
  kSD_set = set(['0.01', '0.02', '0.05', '0.1'])
  if ((kMean in kMean_set) and (kSD in kSD_set)):
    output=subprocess.check_output([
      'docker', 
      'run',
      '-v',
      '/tmp:/data',
      'jjsaeta/clm-4level:entry',
      'tclsh',
      'ClassExTestSmallWat_4L_ReduceStep6_PostDrain_CLM.tcl',
      kMean,
      kSD])
    subStorage=[]
    surfStorage=[]
    runOff=[]
    timeSteps=[]
    with open('/data/SmallWatTest/WaterBalanceVolumes.txt', 'r') as f:
      reader=csv.reader(f,delimiter='\t')
      for subStor, surfStor, outflow in reader:
        subStorage.append(float(subStor))
        surfStorage.append(surfStor)
        runOff.append(outflow)
        timeSteps.append(len(timeSteps))
    return jsonify(timeSteps=timeSteps, subStorage=subStorage)
  else:
    return render_template('500.htm'), 500


@app.route('/d3test')
def testd3():
  return render_template('d3test.html')

@app.route('/docker_ps')
def docker_ps():
  output = subprocess.check_output(['docker', 'ps'])
  return render_template('docker_ps.html', output=output)

@app.route('/ls')
def lscommands():
  result = subprocess.check_output(['ls', '-l'])
  return Response(result, mimetype='text/plain')

@app.route('/lsImages')
def lsImages():
  result = subprocess.check_output(['docker', 'images'])
  return Response(result, mimetype='text/plain')

@app.route('/runContainer')
def runHelloWorld():
  result = subprocess.check_output(['docker',  'run', 'hello-world'])
  return Response(result, mimetype='text/plain')

if __name__ == '__main__':
  app.run(debug=True, host='0.0.0.0', threaded=True)
