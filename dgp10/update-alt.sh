#!/bin/bash

env -i salt-call state.apply | tail -n 20